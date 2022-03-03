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
        
        let tmpResult = cpu.currentOperator!.execute(input: input)
        
        applyTmpResult(finalResult: result, tmpResult: tmpResult)
        
        writeToMemory(results: tmpResult, address: cpu.operand, memory: cpu.memory, memoryAccess: cpu.currentOperator!.requiresAddressOrWriteAccess)
        
        applyStackpointer(result: result, stackpointer: stackpointer)
        
        if testForMemoryUseOfInstruction(input: input, cpu: cpu) {
            setBusses(result: result, cpu: cpu, input: input)
        }
        
        return result
    }
    
    private static func applyTmpResult(finalResult: NewCPUVars, tmpResult: CPUExecutionResult) {
        applyAccumulator(tmpResult, finalResult)
        
        applyVFlag(tmpResult, finalResult)
        
        applyProgramCounter(tmpResult, finalResult)
    }
    
    private static func applyAccumulator(_ tmpResult: CPUExecutionResult, _ finalResult: NewCPUVars) {
        if let accumulator = tmpResult.accumulator {
            finalResult.accumulator = accumulator
        }
    }
    
    private static func applyVFlag(_ tmpResult: CPUExecutionResult, _ finalResult: NewCPUVars) {
        if let vFlag = tmpResult.vFlag {
            finalResult.vFlag = vFlag
        }
    }
    
    private static func applyProgramCounter(_ tmpResult: CPUExecutionResult, _ finalResult: NewCPUVars) {
        if let programCounter = tmpResult.programCounter {
            finalResult.programCounter = programCounter
        }
    }
    
    private static func writeToMemory(results: CPUExecutionResult, address: UInt16, memory: Memory, memoryAccess: Bool) {
        if isWritingAllowed(results: results, memoryAccess: memoryAccess) {
            memory.write(results.toWrite!, address: address)
        }
    }
    
    private static func isWritingAllowed(results: CPUExecutionResult, memoryAccess: Bool) -> Bool {
        results.toWrite != nil && memoryAccess
    }
    
    private static func applyStackpointer(result: NewCPUVars, stackpointer: StackpointerHandler) {
        result.stackpointer = stackpointer.stackpointer
    }
    
    private static func testForMemoryUseOfInstruction(input: CPUExecutionInput, cpu: CPUCopy) -> Bool {
        input.operandRead && cpu.operandType!.providesAddressOrWriteAccess && input.operandValue != nil
    }
    
    private static func setBusses(result: NewCPUVars, cpu: CPUCopy, input: CPUExecutionInput) {
        result.addressBus = cpu.operand
        result.dataBus = input.operandValue!
    }
    
    private static func createInput(cpu: CPUCopy, stackpointer: StackpointerHandler) -> CPUExecutionInput {
        
        let operand = cpu.currentOperator!.requiresAddressOrWriteAccess ? cpu.operand : nil
        
        return CPUExecutionInput(accumulator: cpu.accumulator, nFlag: cpu.nFlag, zFlag: cpu.zFlag, vFlag: cpu.vFlag, stackpointer: stackpointer, operandValue: cpu.operandType?.getOperandValue(cpu: cpu), operand: operand)
    }
    
    static func testIfNoDecodeHappend(cpu: CPUCopy) -> Bool {
        cpu.currentOperator == nil || cpu.operandType == nil
    }

}
