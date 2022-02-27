//
//  FuncExecutionInternal.swift
//  
//
//  Created by Paul on 27.02.22.
//

import Foundation

public class StackpointerHandler {
    private let cpu: CPUCopy
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
    
    fileprivate init(cpu: CPUCopy) {
        self.cpu = cpu
        self.stackpointer = cpu.stackpointer
    }
}

class ExecutionInternal {
    
    static func executeWithAssumptionOfDecoding(cpu: CPUCopy) -> NewCPUVars {
        let result = NewCPUVars()
        
        let stackpointer = StackpointerHandler(cpu: cpu)
        let input = createInput(cpu: cpu, stackpointer: stackpointer)
        
        cpu.currentOperator!.execute(input: input)
        
        applyStackpointer(result: result, stackpointer: stackpointer)
        
        if testForMemoryUseOfInstruction(input: input, cpu: cpu) {
            setBusses(result: result, cpu: cpu, input: input)
        }
        
        return result
    }
    
    private static func applyStackpointer(result: NewCPUVars, stackpointer: StackpointerHandler) {
        result.stackpointer = stackpointer.stackpointer
    }
    
    private static func testForMemoryUseOfInstruction(input: CPUExecutionInput, cpu: CPUCopy) -> Bool {
        input.operandRead && cpu.operandType!.providesAddressOrWriteAccess
    }
    
    private static func setBusses(result: NewCPUVars, cpu: CPUCopy, input: CPUExecutionInput) {
        result.addressBus = cpu.operand
        result.dataBus = input.operandValue!
    }
    
    private static func createInput(cpu: CPUCopy, stackpointer: StackpointerHandler) -> CPUExecutionInput {
        CPUExecutionInput(accumulator: cpu.accumulator, nFlag: cpu.nFlag, zFlag: cpu.zFlag, vFlag: cpu.vFlag, stackpointer: stackpointer, operandValue: cpu.operandType?.getOperandValue(cpu: cpu))
    }
    
    static func testIfNoDecodeHappend(cpu: CPUCopy) -> Bool {
        cpu.currentOperator == nil || cpu.operandType == nil
    }

}
