//
//  CPUExecutionOutputTests.swift
//  
//
//  Created by Paul on 03.03.22.
//

import XCTest
import CPU_Simulation_Lib

class CPUExecutionOutputTests: XCTestCase {
    
    var memory = Memory()
    var cpu: CPU!
    
    override func setUp() {
        cpu = CPU(memory: memory)
        StandardOperators.operators.append(ExecOutputWriteOperator.init)
        StandardOperators.operators.append(ExecOutputLiteralOperator.init)
        StandardOperators.operators.append(ExecOutputStandardOperator.init)
        StandardOperators.operators.append(ExecOutputNothingOperator.init)
    }
    
    func testExecOutputStandard() {
        XCTAssertNoThrow(try memory.writeValues(values: [0x1cc, 0x100]))
        memory.write(0x555, address: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "EXEC-OUT-STANDARD")
        
        XCTAssertEqual(cpu.accumulator, 0x555)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertEqual(memory.read(address: 0x100), 0x555)
    }
    
    func testExecOutputWriteAndAddressAccess() {
        XCTAssertNoThrow(try memory.writeValues(values: [0x3aa, 0x100]))
        memory.write(0x555, address: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "EXEC-OUT-WRITE")
        
        XCTAssertEqual(cpu.programCounter, 0x555)
        XCTAssertEqual(memory.read(address: 0x555), 0xffff)
        
    }
    
    func testExecOutputLiteral() {
        XCTAssertNoThrow(try memory.writeValues(values: [0x2bb, 0x100]))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "EXEC-OUT-LITERAL")
        
        XCTAssertEqual(cpu.accumulator, 0x100)
        XCTAssertEqual(memory.read(address: 0x100), 0)
        
    }
    
    func testExecOutputNothing() {
        memory.write(0xdd, address: 0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "EXEC-OUT-NOTHING")
        
        XCTAssertEqual(cpu.accumulator, 0x20)
        XCTAssertEqual(memory.read(address: 0), 0xdd)
        
    }

}

private class ExecOutputWriteOperator: Operator {
    
    static var requiresAddressOrWriteAccess: Bool { true }
    
    static var requiresLiteralReadAccess: Bool { false }
    
    static var operatorCode: UInt8 { 0xaa }
    
    static var stringRepresentation: String { "EXEC-OUT-WRITE" }
    
    static var dontAllowOperandIfPossible: Bool { false }
    
    func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.programCounter = input.operand
        result.toWrite = 0xffff
        
        return result
    }
    
    required public init() {}
}

private class ExecOutputLiteralOperator: Operator {
    static var requiresAddressOrWriteAccess: Bool { false }
    
    static var requiresLiteralReadAccess: Bool { true }
    
    static var operatorCode: UInt8 { 0xbb }
    
    static var stringRepresentation: String { "EXEC-OUT-LITERAL" }
    
    static var dontAllowOperandIfPossible: Bool { false }
    
    func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = input.operandValue
        result.toWrite = 0x20
        
        return result
    }
    
    required public init() {}
}

private class ExecOutputStandardOperator: Operator {
    static var requiresAddressOrWriteAccess: Bool { false }
    
    static var requiresLiteralReadAccess: Bool { false }
    
    static var operatorCode: UInt8 { 0xcc }
    
    static var stringRepresentation: String { "EXEC-OUT-STANDARD" }
    
    static var dontAllowOperandIfPossible: Bool { false }
    
    func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = input.operandValue
        result.vFlag = true
        result.toWrite = 0x20
        
        return result
    }
    
    required public init() {}
}

private class ExecOutputNothingOperator: Operator {
    static var requiresAddressOrWriteAccess: Bool { false }
    
    static var requiresLiteralReadAccess: Bool { false }
    
    static var operatorCode: UInt8 { 0xdd }
    
    static var stringRepresentation: String { "EXEC-OUT-NOTHING" }
    
    static var dontAllowOperandIfPossible: Bool { true }
    
    func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = 0x20
        result.toWrite = 0x100
        
        return result
    }
    
    required public init() {}
}
