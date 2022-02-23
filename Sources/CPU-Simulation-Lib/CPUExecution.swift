//
//  CPUExecution.swift
//  
//
//  Created by Paul on 17.02.22.
//

import Foundation

public class CPUExecutionInput {
    public let accumulator: UInt16
    public let nFlag: Bool
    public let zFlag: Bool
    public let vFlag: Bool
    public let stackpointer: StackpointerHandler
    
    private var _operandValue: UInt16?
    public var operandValue: UInt16? {
        _operandRead = true
        return _operandValue
    }
    private var _operandRead = false
    public var operandRead: Bool {
        _operandRead
    }
    
    public init(accumulator: UInt16, nFlag: Bool, zFlag: Bool, vFlag: Bool, stackpointer: StackpointerHandler, operandValue: UInt16?) {
        self.accumulator = accumulator
        self.nFlag = nFlag
        self.zFlag = zFlag
        self.vFlag = vFlag
        self.stackpointer = stackpointer
        self._operandValue = operandValue
    }
}

public class StackpointerHandler {
    private let cpu: CPU
    fileprivate var stackpointer: UInt16
    private var memory: Memory { cpu.memory }
    
    public var underlyingValue: UInt16 {
        return memory.read(address: stackpointer)
    }
    
    public static postfix func ++(handler: StackpointerHandler) {
        handler.stackpointer &+= 1
    }
    
    public static postfix func --(handler: StackpointerHandler) {
        handler.stackpointer &-= 1
    }
    
    fileprivate init(cpu: CPU) {
        self.cpu = cpu
        self.stackpointer = cpu.stackpointer
    }
}

public func executeInstruction(cpu: CPU) -> NewCPUVars {
    if testIfNoDecodeHappend(cpu: cpu)  {
        return NewCPUVars()
    }
    
    return executeWithAssumptionOfDecoding(cpu: cpu)
}

private func executeWithAssumptionOfDecoding(cpu: CPU) -> NewCPUVars {
    let result = NewCPUVars()
    
    let stackpointer = StackpointerHandler(cpu: cpu)
    let input = createInput(cpu: cpu, stackpointer: stackpointer)
    
    cpu.currentOperator!.operate(input: input)
    
    applyStackpointer(result: result, stackpointer: stackpointer)
    
    if testForMemoryUseOfInstruction(input: input, cpu: cpu) {
        setBusses(result: result, cpu: cpu, input: input)
    }
    
    return result
}

private func applyStackpointer(result: NewCPUVars, stackpointer: StackpointerHandler) {
    result.stackpointer = stackpointer.stackpointer
}

private func testForMemoryUseOfInstruction(input: CPUExecutionInput, cpu: CPU) -> Bool {
    input.operandRead && cpu.operandType!.providesAddressOrWriteAccess
}

private func setBusses(result: NewCPUVars, cpu: CPU, input: CPUExecutionInput) {
    result.addressBus = cpu.operand
    result.dataBus = input.operandValue!
}

private func createInput(cpu: CPU, stackpointer: StackpointerHandler) -> CPUExecutionInput {
    CPUExecutionInput(accumulator: cpu.accumulator, nFlag: cpu.nFlag, zFlag: cpu.zFlag, vFlag: cpu.vFlag, stackpointer: stackpointer, operandValue: cpu.operandType?.getOperandValue(cpu: cpu))
}

private func testIfNoDecodeHappend(cpu: CPU) -> Bool {
    cpu.currentOperator == nil || cpu.operandType == nil
}
