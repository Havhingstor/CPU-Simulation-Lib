//
//  FuncExecution.swift
//  
//
//  Created by Paul on 17.02.22.
//

import Foundation

private typealias Internal = ExecutionInternal

public class CPUExecutionInput {
    public let accumulator: UInt16
    public let nFlag: Bool
    public let zFlag: Bool
    public let vFlag: Bool
    public let stackpointer: StackpointerHandler
    public let operand: UInt16?
    public let operatorAddress: UInt16
    public let programCounter: UInt16
    
    private var _operandValue: UInt16?
    public var operandValue: UInt16? {
        _operandRead = true
        return _operandValue
    }
    private var _operandRead = false
    public var operandRead: Bool {
        _operandRead
    }
    
    public init(accumulator: UInt16, nFlag: Bool, zFlag: Bool, vFlag: Bool, stackpointer: StackpointerHandler, operandValue: UInt16?,
                operand: UInt16?, operatorAddress: UInt16, programCounter: UInt16) {
        self.accumulator = accumulator
        self.nFlag = nFlag
        self.zFlag = zFlag
        self.vFlag = vFlag
        self.stackpointer = stackpointer
        self._operandValue = operandValue
        self.operand = operand
        self.operatorAddress = operatorAddress
        self.programCounter = programCounter
    }
}

public struct CPUExecutionResult {
    public var accumulator: UInt16?
    public var vFlag: Bool?
    public var zFlag: Bool? = nil
    public var nFlag: Bool? = nil
    public var programCounter: UInt16?
    public var toWrite: UInt16?
    public var continuation = CPUContinuation.standard
    
    public init() {}
}

public func executeInstruction(cpu: CPUCopy) throws -> NewCPUVars {
    if Internal.testIfNoDecodeHappend(cpu: cpu)  {
        return NewCPUVars()
    }
    
    return try Internal.executeWithAssumptionOfDecoding(cpu: cpu)
}
