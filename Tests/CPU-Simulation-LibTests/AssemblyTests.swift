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
    
    func testError() {
        let assembly = """
            LOAD    10  This is not a comment
        """
        
        XCTAssertThrowsError(try memory.loadAssembly(assemblyCode: assembly)) { err in
            print(err)
        }
    }
    
    func testErrorWithValidOperator() {
        let assembly = """
            LOAD    10  ADD 22
        """
        
        XCTAssertThrowsError(try memory.loadAssembly(assemblyCode: assembly)) { err in
            print(err)
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
            print(err)
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
}
