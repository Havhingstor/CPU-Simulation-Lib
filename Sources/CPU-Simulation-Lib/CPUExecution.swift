//
//  CPUExecution.swift
//  
//
//  Created by Paul on 17.02.22.
//

import Foundation

public struct CPUExecutionInput {
    public var accumulator: UInt16
    public var nFlag: Bool
    public var zFlag: Bool
    public var vFlag: Bool
    public var operandValue: UInt16?
    public var stackpointer: StackpointerHandler
}

public struct StackpointerHandler {
    private var cpu: CPU
    private var stackpointer: StackpointerHolder
    private var memory: Memory { cpu.memory }
    
    public var underlyingValue: UInt16 {
        return memory.read(address: stackpointer.stackpointer)
    }
    
    public static postfix func ++(handler: inout StackpointerHandler) {
        handler.stackpointer.stackpointer &+= 1
    }
    
    public static postfix func --(handler: inout StackpointerHandler) {
        handler.stackpointer.stackpointer &-= 1
    }
    
    fileprivate init(cpu: CPU, stackpointer: StackpointerHolder) {
        self.cpu = cpu
        self.stackpointer = stackpointer
    }
}

public func executeInstruction(cpu: CPU) -> NewCPUVars {
    if testIfNoDecodeHappend(cpu: cpu)  {
        return NewCPUVars()
    }
    
    return operate(cpu: cpu)
}

private func operate(cpu: CPU) -> NewCPUVars {
    let stackpointer = StackpointerHolder(cpu: cpu)
    let input = createInput(cpu: cpu, stackpointer: stackpointer)
    
    cpu.currentOperator!.operate(input: input)
    
    let result = NewCPUVars()
    result.stackpointer = stackpointer.stackpointer
    
    return result
}

private func createInput(cpu: CPU, stackpointer: StackpointerHolder) -> CPUExecutionInput {
    CPUExecutionInput(accumulator: cpu.accumulator,
                      nFlag: cpu.nFlag,
                      zFlag: cpu.zFlag,
                      vFlag: cpu.vFlag,
                      operandValue: cpu.operandType!.getOperandValue(cpu: cpu),
                      stackpointer: StackpointerHandler(cpu: cpu, stackpointer: stackpointer))
}

private func testIfNoDecodeHappend(cpu: CPU) -> Bool {
    cpu.currentOperator == nil || cpu.operandType == nil
}

private class StackpointerHolder {
    fileprivate var stackpointer: UInt16
    
    fileprivate init(cpu: CPU) {
        stackpointer = cpu.stackpointer
    }
}

