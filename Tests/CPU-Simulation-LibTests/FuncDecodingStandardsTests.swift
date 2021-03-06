//
//  InstructionTests.swift
//  
//
//  Created by Paul on 12.02.22.
//

import XCTest
import CPU_Simulation_Lib

class InstructionTests: XCTestCase {
    var memory = Memory()
    var cpu: CPU!
    
    override func setUp() {
        cpu = CPU(memory: memory)
        OperandFetchedState.standardNextState = OwnExecution.init
    }
    
    override class func tearDown() {
        OperandFetchedState.resetStandardNextState()
    }
    
    func testOperators() {
        XCTAssertNoThrow(try memory.writeValues(values: [0x114, 0x100, 0x115, 0x200, 0x10A, 0x100, 0x10B, 0x100, 0x10C, 0x100, 0x10D, 0x100, 0x10E, 0x100, 0x10F, 0x100,
                                         0x128, 0x100, 0x129, 0x100, 0x12A, 0x100, 0x12B, 0x100, 0x12C, 0x100, 0x12D, 0x100, 0x11E, 0x100, 0x11F,
                                         0x100, 0x120, 0x100, 0x121, 0x100, 0x122, 0x100, 0x123, 0x100, 0x125, 0x100, 0x124, 0x100, 0x105, 0x100,
                                         0x207, 0x100, 0x208, 0x100, 0x0, 0x100, 0x63, 0x100, 0x1, 0x100, 0x2E, 0x100, 0x6, 0x100, 0x19, 0x100,
                                         0x1A, 0x100]))
        
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.operand, 0)
        XCTAssertEqual(cpu.operatorString, "NOOP")
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x114)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "LOAD")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x115)
        XCTAssertEqual(cpu.operand, 0x200)
        XCTAssertEqual(cpu.operatorString, "STORE")
        XCTAssertTrue(cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x10A)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "ADD")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x10B)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "SUB")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x10C)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "MUL")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x10D)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "DIV")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x10E)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "MOD")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x10F)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "CMP")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x128)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "AND")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x129)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "OR")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x12A)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "XOR")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x12B)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "SHL")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x12C)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "SHR")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x12D)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "SHRA")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x11E)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPP")
        XCTAssertTrue(cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x11F)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPNN")
        XCTAssertTrue(cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x120)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPN")
        XCTAssertTrue(cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x121)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPNP")
        XCTAssertTrue(cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x122)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPZ")
        XCTAssertTrue(cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x123)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPNZ")
        XCTAssertTrue(cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x125)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPV")
        XCTAssertTrue(cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x124)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMP")
        XCTAssertTrue(cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x105)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "JSR")
        XCTAssertTrue(cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x207)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "RSV")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x208)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "REL")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(!cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x0)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "NOOP")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x63)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "HOLD")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x1)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "RESET")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x2E)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "NOT")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x6)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "RTS")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x19)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "PUSH")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(cpu.`operator`!.allowsNoOperand)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x1A)
        XCTAssertEqual(cpu.operand, 0x100)
        XCTAssertEqual(cpu.operatorString, "POP")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(cpu.`operator`!.allowsNoOperand)
    }
    
    func testDecodingError() {
        memory.write(0xff, address: 0)
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUSimErrors, CPUSimErrors.OperatorCodeNotDecodable(address: 0, operatorCode: 0xff))
        }
    }
    
    func testDecodingOfOperatorCodeWhenInputWithOperandTypeCode() {
        XCTAssertNoThrow(try memory.writeValues(values: [0, 0, 0x614, 0, 0x40E]))
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.operatorString, "NOOP")
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.`operator`!.operatorCode, 0)
        XCTAssertEqual(cpu.operatorString, "NOOP")
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x614)
        XCTAssertEqual(cpu.`operator`!.operatorCode, 0x14)
        XCTAssertEqual(cpu.operatorString, "LOAD")
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0x40E)
        XCTAssertEqual(cpu.`operator`!.operatorCode, 0xE)
        XCTAssertEqual(cpu.operatorString, "MOD")
    }
    
    func testOwnInstruction() {
        StandardOperators.operators.append(OwnOperator.init)
        memory.write(0xff, address: 0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "OWN")
        XCTAssertTrue(!cpu.`operator`!.requiresAddressOrWriteAccess)
        XCTAssertTrue(!cpu.`operator`!.requiresLiteralReadAccess)
        XCTAssertTrue(cpu.`operator`!.allowsNoOperand)
        
        cpu.reset()
        StandardOperators.resetOperators()
         
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUSimErrors, CPUSimErrors.OperatorCodeNotDecodable(address: 0, operatorCode: 0xff))
        }
    }
}

fileprivate class OwnOperator: Operator {
    func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        return CPUExecutionResult()
    }
    
    static var operatorCode: UInt8 { 0xff }
    
    static var stringRepresentation: String {"OWN"}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}
