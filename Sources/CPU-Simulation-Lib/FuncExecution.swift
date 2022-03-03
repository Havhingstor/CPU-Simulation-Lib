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
    
    private var _operandValue: UInt16?
    public var operandValue: UInt16? {
        _operandRead = true
        return _operandValue
    }
    private var _operandRead = false
    public var operandRead: Bool {
        _operandRead
    }
    
    public init(accumulator: UInt16, nFlag: Bool, zFlag: Bool, vFlag: Bool, stackpointer: StackpointerHandler, operandValue: UInt16?, operand: UInt16?) {
        self.accumulator = accumulator
        self.nFlag = nFlag
        self.zFlag = zFlag
        self.vFlag = vFlag
        self.stackpointer = stackpointer
        self._operandValue = operandValue
        self.operand = operand
    }
}

public func executeInstruction(cpu: CPUCopy) -> NewCPUVars {
    if Internal.testIfNoDecodeHappend(cpu: cpu)  {
        return NewCPUVars()
    }
    
    return Internal.executeWithAssumptionOfDecoding(cpu: cpu)
}
