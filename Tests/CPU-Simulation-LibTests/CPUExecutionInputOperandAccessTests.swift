//
//  CPUExecutionInputOperandAccessTests.swift
//  
//
//  Created by Paul on 03.03.22.
//

import XCTest
import CPU_Simulation_Lib

class CPUExecutionInputOperandAccessTests: XCTestCase {

    var memory = Memory()
    var cpu: CPU!
    static var operand: UInt16?
    
    override func setUp() {
        cpu = CPU(memory: memory)
        StandardOperators.operators.append(InputOAWriteOperator.init)
        StandardOperators.operators.append(InputOALiteralOperator.init)
        StandardOperators.operators.append(InputOAStandardOperator.init)
        StandardOperators.operators.append(InputOANothingOperator.init)
    }
    
    func testInputOperandAccess() {
        XCTAssertNoThrow(try memory.writeValues(values: [0x1aa, 0x100, 0x2bb, 0x100, 0x1cc, 0x100, 0xdd]))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(Self.operand, 0x100)
        Self.operand = nil
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(Self.operand, nil)
        Self.operand = nil
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(Self.operand, nil)
        Self.operand = nil
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(Self.operand, nil)
        Self.operand = nil
    }
    
    override class func tearDown() {
        StandardOperators.resetOperators()
    }
    
}

private func copyOperand(input: CPUExecutionInput) {
    CPUExecutionInputOperandAccessTests.operand = input.operand
}

private class InputOAWriteOperator: Operator {
    static var requiresAddressOrWriteAccess: Bool { true }
    
    static var requiresLiteralReadAccess: Bool { false }
    
    static var operatorCode: UInt8 { 0xaa }
    
    static var stringRepresentation: String { "WRITE" }
    
    static var dontAllowOperandIfPossible: Bool { false }
    
    func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        copyOperand(input: input)
        return CPUExecutionResult()
    }
    
    required public init() {}
}

private class InputOALiteralOperator: Operator {
    static var requiresAddressOrWriteAccess: Bool { false }
    
    static var requiresLiteralReadAccess: Bool { true }
    
    static var operatorCode: UInt8 { 0xbb }
    
    static var stringRepresentation: String { "LITERAL" }
    
    static var dontAllowOperandIfPossible: Bool { false }
    
    func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        copyOperand(input: input)
        return CPUExecutionResult()
    }
    
    required public init() {}
}

private class InputOAStandardOperator: Operator {
    static var requiresAddressOrWriteAccess: Bool { false }
    
    static var requiresLiteralReadAccess: Bool { false }
    
    static var operatorCode: UInt8 { 0xcc }
    
    static var stringRepresentation: String { "STANDARD" }
    
    static var dontAllowOperandIfPossible: Bool { false }
    
    func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        copyOperand(input: input)
        return CPUExecutionResult()
    }
    
    required public init() {}
}

private class InputOANothingOperator: Operator {
    static var requiresAddressOrWriteAccess: Bool { false }
    
    static var requiresLiteralReadAccess: Bool { false }
    
    static var operatorCode: UInt8 { 0xdd }
    
    static var stringRepresentation: String { "NOTHING" }
    
    static var dontAllowOperandIfPossible: Bool { true }
    
    func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        copyOperand(input: input)
        return CPUExecutionResult()
    }
    
    required public init() {}
}
