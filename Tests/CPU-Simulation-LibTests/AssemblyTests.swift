//
//  AssemblyTests.swift
//  
//
//  Created by Paul on 10.03.22.
//

import XCTest
import CPU_Simulation_Lib

class AssemblyTests: XCTestCase {

    var memory = Memory()
    var cpu: CPU!
    
    override func setUp() {
        cpu = CPU(memory: memory)
    }
    
    func testVarsAndWords() {
        let assembly = """
        var1:
                WORD    0

        var2:   word    10
        """
        
        let assemblyResults = try? memory.loadAssembly(assemblyCode: assembly)
        XCTAssertNotNil(assemblyResults)
        
        guard assemblyResults != nil else {
            return
        }
            
        XCTAssertEqual(memory.read(address: 0), 0)
        XCTAssertEqual(memory.read(address: 1), 10)
        
        let vars = assemblyResults!.markers
        
        guard vars.count > 0 else {
            XCTFail("No Vars!")
            return
        }
        
        XCTAssertEqual(vars[0].name, "var1")
        XCTAssertEqual(vars[0].address, 0)
        XCTAssertEqual(vars[0].type, .variable)
        XCTAssertEqual(vars[1].name, "var2")
        XCTAssertEqual(vars[1].address, 1)
        XCTAssertEqual(vars[0].type, .variable)
        
        let memoryValueTypes = assemblyResults!.memoryValues
        
        XCTAssertNotNil(memoryValueTypes[0] as? AssemblingResults.LiteralAddressValue)
        XCTAssertNotNil(memoryValueTypes[1] as? AssemblingResults.LiteralAddressValue)
    }
    
    func testOperatorAndOperand() {
        let assembly = """
        LOAD    10
        ADD     $20
        """
        
        let assemblyResultsTmp = try? memory.loadAssembly(assemblyCode: assembly)
        XCTAssertNotNil(assemblyResultsTmp)
        
        guard assemblyResultsTmp != nil else {
            return
        }
        
        XCTAssertNotEqual(memory.read(address: 0), 0)
        XCTAssertEqual(memory.read(address: 1), 10)
        XCTAssertNotEqual(memory.read(address: 2), 0)
        XCTAssertEqual(memory.read(address: 3), 20)
        
        let memoryValueTypes = assemblyResultsTmp!.memoryValues
        
        XCTAssertNotNil(memoryValueTypes[0] as? AssemblingResults.OpcodeAddressValue)
        XCTAssertNotNil(memoryValueTypes[1] as? AssemblingResults.AddressAddressValue)
        
        XCTAssertNotNil(memoryValueTypes[2] as? AssemblingResults.OpcodeAddressValue)
        XCTAssertNotNil(memoryValueTypes[3] as? AssemblingResults.LiteralAddressValue)

    }
    
    func testAppendedI() {
        let assembly = """
            LOAD    10
            ADDI    20
            SUB     $30
        """
        
        XCTAssertNoThrow(try memory.loadAssembly(assemblyCode: assembly))
        
        XCTAssertNotEqual(memory.read(address: 0), 0)
        XCTAssertEqual(memory.read(address: 1), 10)
        XCTAssertNotEqual(memory.read(address: 2), 0)
        XCTAssertEqual(memory.read(address: 3), 20)
        XCTAssertNotEqual(memory.read(address: 4), 0)
        XCTAssertEqual(memory.read(address: 5), 30)
    }
    
    func testReferencedMarker() {
        let assembly = """
            LOAD    10
        start:
            ADD     start
        """
        
        let assemblyResultsTmp = try? memory.loadAssembly(assemblyCode: assembly)
        XCTAssertNotNil(assemblyResultsTmp)
        
        XCTAssertNotEqual(memory.read(address: 0), 0)
        XCTAssertEqual(memory.read(address: 1), 10)
        XCTAssertNotEqual(memory.read(address: 2), 0)
        XCTAssertEqual(memory.read(address: 3), 2)
    }
    
    func testStackpointer() {
        let assembly = """
        LOAD    10(SP)
        ADD     $20
        """
        
        let assemblyResultsTmp = try? memory.loadAssembly(assemblyCode: assembly)
        XCTAssertNotNil(assemblyResultsTmp)
        
        XCTAssertNotEqual(memory.read(address: 0), 0)
        XCTAssertEqual(memory.read(address: 1), 10)
        XCTAssertNotEqual(memory.read(address: 2), 0)
        XCTAssertEqual(memory.read(address: 3), 20)
        
        guard assemblyResultsTmp != nil else {
            return
        }
        
        let memoryValueTypes = assemblyResultsTmp!.memoryValues
                
        XCTAssertEqual((memoryValueTypes[0] as? AssemblingResults.OpcodeAddressValue)?.transform(), "LOAD(SP)")
        XCTAssertNotNil(memoryValueTypes[1] as? AssemblingResults.AddressAddressValue)
        
        XCTAssertEqual((memoryValueTypes[2] as? AssemblingResults.OpcodeAddressValue)?.transform(), "ADD$")
        XCTAssertNotNil(memoryValueTypes[3] as? AssemblingResults.LiteralAddressValue)
    }
    
    func testComments() {
        let assembly = """
            LOAD    10  # This is a comment
        """
        
        XCTAssertNoThrow(try memory.loadAssembly(assemblyCode: assembly))
    }
    
    func testTabs() {
        let assembly = """
        \tLOAD    10
        """
        
        XCTAssertNoThrow(try memory.loadAssembly(assemblyCode: assembly))
    }
    
    func testTooManyOperandsError() {
        let assembly = """
            LOAD    10  This is not a comment
        """
        
        XCTAssertThrowsError(try memory.loadAssembly(assemblyCode: assembly)) { err in
            switch err as? AssemblerErrors {
            case .TooManyOperandsError(let operand, let line):
                XCTAssertEqual(operand, "This")
                XCTAssertEqual(line, 1)
            default:
                XCTFail("\(String(describing: err)) is no TooManyOperandsError")
            }
        }
    }
    
    func testTooManyOperandsErrorWithValidOperator() {
        let assembly = """
            LOAD    10  ADD 22
        """
        
        XCTAssertThrowsError(try memory.loadAssembly(assemblyCode: assembly)) { err in
            switch err as? AssemblerErrors {
            case let .TooManyOperandsError(operand, line):
                XCTAssertEqual(operand, "ADD")
                XCTAssertEqual(line, 1)
            default:
                XCTFail("\(String(describing: err)) is no TooManyOperandsError")
            }
        }
    }
    
    func testErrorRightLine() {
        let assembly = """
            LOAD    10
            ADDI    20
            SUB     $30
            err
        """
        
        XCTAssertThrowsError(try memory.loadAssembly(assemblyCode: assembly)) { err in
            switch err as? AssemblerErrors {
            case let .OperatorNotDecodableError(`operator`, line):
                XCTAssertEqual(`operator`, "err")
                XCTAssertEqual(line, 4)
            default:
                XCTFail("\(String(describing: err)) is no OperatorNotDecodableError")
            }
        }
    }
    
    func testMultiplicate() {
        let assembly = """
                JMP     Start
        Var1:   WORD    100
        Var2:   WORD    15
        Tmp:    WORD    0
        Result: WORD    0
        Start:
                LOAD    Var2
                CMP     Var1
                JLE     Start2
                STORE   Tmp
                LOAD    Var1
                STORE   Var2
                LOAD    Tmp
                STORE   Var1
                LOAD    Var2
        Start2:
                STORE   Tmp
        MemL:   LOAD    Tmp
                JMPZ    End
                JMPN    MemN
        MemP:   LOAD    Result
                ADD     Var1
                STORE   Result
                LOAD    Tmp
                SUB     $1
                STORE   Tmp
                JMP     MemL
        MemN:   LOAD    Result
                SUB     Var1
                STORE   Result
                LOAD    Tmp
                ADD     $1
                STORE   Tmp
                JMP     MemL
        End:    HOLD
        """
        
        XCTAssertNoThrow(try memory.loadAssembly(assemblyCode: assembly))
        
        XCTAssertNoThrow(try cpu.run())
        
        XCTAssertEqual(memory.read(address: 5), 1500)
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertEqual(cpu.programCounter, 62)
    }
    
    func testAddressTypeTransformations() {
        let assembly = """
        LOAD    $100
        STORE   500
        """
        
        let assemblingResults = try? memory.loadAssembly(assemblyCode: assembly)
        XCTAssertNotNil(assemblingResults)
        
        let values = assemblingResults!.memoryValues
        
        let literalAddressType = values[1]
        let addressAddressType = values[3]
        let operatorAddressType = values[0]
        
        XCTAssertNotNil(literalAddressType)
        XCTAssertNotNil(addressAddressType)
        XCTAssertNotNil(operatorAddressType)
        
        XCTAssertNotNil(literalAddressType as? AssemblingResults.LiteralAddressValue)
        XCTAssertNotNil(addressAddressType as? AssemblingResults.AddressAddressValue)
        XCTAssertNotNil(operatorAddressType as? AssemblingResults.OpcodeAddressValue)
        
        if(literalAddressType != nil) {
            XCTAssertEqual(literalAddressType!.transform(), "100")
            XCTAssertEqual(literalAddressType!.transformOnlyNumber(), "100")
        }
        
        if(addressAddressType != nil) {
            XCTAssertEqual(addressAddressType!.transform(), "0x01F4")
            XCTAssertEqual(addressAddressType!.transformOnlyNumber(), "0x01F4")
        }
        
        if(operatorAddressType != nil) {
            XCTAssertEqual(operatorAddressType!.transform(), "LOAD$")
            XCTAssertEqual(operatorAddressType!.transformOnlyNumber(), "0x0214")
        }
    }
    
    func testNonExistingMarkerError() {
        let assembly = """
        STORE   loc
        """
        
        XCTAssertThrowsError(try memory.loadAssembly(assemblyCode: assembly)) { err in
            switch err as? AssemblerErrors {
            case let .MarkerDoesntExistError(marker, line):
                XCTAssertEqual(marker, "loc")
                XCTAssertEqual(line, 1)
            default:
                XCTFail("\(String(describing: err)) is no MarkerDoesntExistError")
            }
        }
    }
    
    func testMarkerExistsTwiceError() {
        let assembly = """
        loc:
            LOAD    $10
        loc:
            LOAD    $10
        """
        
        XCTAssertThrowsError(try memory.loadAssembly(assemblyCode: assembly)) { err in
            switch err as? AssemblerErrors {
            case let .MarkerExistsTwiceError(marker, line):
                XCTAssertEqual(marker, "loc")
                XCTAssertEqual(line, 4)
            default:
                XCTFail("\(String(describing: err)) is no MarkerExistsTwiceError")
            }
        }
    }
    
    func testTooBigProgramError() {
        var assembly = ""
        
        for _ in 0...0x10000 {
            assembly += "LOAD   $1\n"
        }
        
        XCTAssertThrowsError(try memory.loadAssembly(assemblyCode: assembly)) { err in
            switch err as? AssemblerErrors {
            case .ProgramTooBigError:
                break
            default:
                XCTFail("\(String(describing: err)) is no ProgramTooBigError")
            }
        }
    }
    
    func testWordValueMissingError() {
        let assembly = """
        WORD
        """
        
        XCTAssertThrowsError(try memory.loadAssembly(assemblyCode: assembly)) { err in
            switch err as? AssemblerErrors {
            case let .WordValueMissingError(line):
                XCTAssertEqual(line, 1)
            default:
                XCTFail("\(String(describing: err)) is no WordValueMissingError")
            }
        }
    }
    
    func testEndWithoutNewline() {
        let assembly = "HOLD"
        
        XCTAssertNoThrow(try memory.loadAssembly(assemblyCode: assembly))
    }
    
    func testOperandNotDecodableErrorIfTypeIsntDecodable() {
        let assembly = """
        LOAD    &1
        """
        
        XCTAssertThrowsError(try memory.loadAssembly(assemblyCode: assembly)) { err in
            switch err as? AssemblerErrors {
            case let .OperandNotDecodableError(operand, line):
                XCTAssertEqual(operand, "&1")
                XCTAssertEqual(line, 1)
            default:
                XCTFail("\(String(describing: err)) is no OperandNotDecodableError")
            }
        }
    }
    
    func testOperandNotDecodableErrorIfTokenIsntOperand() {
        let assembly = """
        LOAD    Test:
        """
        
        XCTAssertThrowsError(try memory.loadAssembly(assemblyCode: assembly)) { err in
            switch err as? AssemblerErrors {
            case let .OperandNotDecodableError(operand, line):
                XCTAssertEqual(operand, "Test:")
                XCTAssertEqual(line, 1)
            default:
                XCTFail("\(String(describing: err)) is no OperandNotDecodableError")
            }
        }
    }
    
    func testAssemblingNumberFormats() {
        let assembly = """
        LOAD    $0b1010010
        STORE   0x100
        """
        
        XCTAssertNoThrow(try memory.loadAssembly(assemblyCode: assembly))
        XCTAssertEqual(memory.read(address: 1), 82)
        XCTAssertEqual(memory.read(address: 3), 256)
    }
}
