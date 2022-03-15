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
    
    fileprivate var addressBus: UInt16? = nil
    fileprivate var dataBus: UInt16? = nil
    
    public var underlyingValue: UInt16 {
        get {
            let value = memory.read(address: stackpointer)
            
            addressBus = stackpointer
            dataBus = value
            
            return value
        }
        set(value) {
            memory.write(value, address: stackpointer)
            
            addressBus = stackpointer
            dataBus = value
        }
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
    
    static func executeWithAssumptionOfDecoding(cpu: CPUCopy) throws -> NewCPUVars {
        var result = NewCPUVars()
        
        let stackpointer = StackpointerHandler(cpu: cpu)
        let input = createInput(cpu: cpu, stackpointer: stackpointer)
        
       let tmpResult = try cpu.`operator`!.execute(input: input)
        
        applyTmpResult(finalResult: &result, tmpResult: tmpResult)
        
        writeToOperandLocation(results: tmpResult, address: cpu.operand, memory: cpu.memory, memoryAccess: cpu.`operator`!.requiresAddressOrWriteAccess)
        
        setBussesFromStackChanges(result: result, stack: stackpointer)
        overwriteBussesWhenWrittenToOperandLocation(finalResult: result, tmpResult: tmpResult, address: cpu.operand, memory: cpu.memory, memoryAccess: cpu.`operator`!.requiresAddressOrWriteAccess)
        
        applyStackpointer(result: result, stackpointer: stackpointer)
        
        if testForMemoryUseOfInstruction(input: input, cpu: cpu) {
            setBusses(result: result, cpu: cpu, input: input)
        }
        
        return result
    }
    
    private static func applyTmpResult(finalResult: inout NewCPUVars, tmpResult: CPUExecutionResult) {
        applyAccumulator(tmpResult, finalResult)
        
        applyVFlag(tmpResult, finalResult)
        applyZFlag(tmpResult, &finalResult)
        applyNFlag(tmpResult, finalResult)
        
        applyProgramCounter(tmpResult, finalResult)
        
        applyHold(tmpResult, finalResult)
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
    
    private static func applyZFlag(_ tmpResult: CPUExecutionResult, _ finalResult: inout NewCPUVars) {
        if let zFlag = tmpResult.zFlag {
            finalResult.zFlag = zFlag
        }
    }
    
    private static func applyNFlag(_ tmpResult: CPUExecutionResult, _ finalResult: NewCPUVars) {
        if let nFlag = tmpResult.nFlag {
            finalResult.nFlag = nFlag
        }
    }
    
    private static func applyProgramCounter(_ tmpResult: CPUExecutionResult, _ finalResult: NewCPUVars) {
        if let programCounter = tmpResult.programCounter {
            finalResult.programCounter = programCounter
        }
    }
    
    private static func applyHold(_ tmpResult: CPUExecutionResult, _ finalResult: NewCPUVars) {
        finalResult.continuation = tmpResult.continuation
    }
    
    private static func writeToOperandLocation(results: CPUExecutionResult, address: UInt16, memory: Memory, memoryAccess: Bool) {
        if hasWrittenToOperandLocation(results: results, memoryAccess: memoryAccess) {
            memory.write(results.toWrite!, address: address)
        }
    }
    
    private static func setBussesFromStackChanges(result: NewCPUVars, stack: StackpointerHandler) {
        if hasWrittenToStack(stack) {
            result.addressBus = stack.addressBus!
            result.dataBus = stack.dataBus!
        }
    }
    
    private static func overwriteBussesWhenWrittenToOperandLocation(finalResult: NewCPUVars, tmpResult: CPUExecutionResult, address: UInt16,
                                                                    memory: Memory, memoryAccess: Bool) {
        if hasWrittenToOperandLocation(results: tmpResult, memoryAccess: memoryAccess) {
            finalResult.addressBus = address
            finalResult.dataBus = tmpResult.toWrite!
        }
    }
    
    private static func hasWrittenToStack(_ stack: StackpointerHandler) -> Bool {
        stack.addressBus != nil && stack.dataBus != nil
    }
    
    private static func hasWrittenToOperandLocation(results: CPUExecutionResult, memoryAccess: Bool) -> Bool {
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
        
        let operand = cpu.`operator`!.requiresAddressOrWriteAccess ? cpu.operand : nil
        
        return CPUExecutionInput(accumulator: cpu.accumulator, nFlag: cpu.nFlag, zFlag: cpu.zFlag, vFlag: cpu.vFlag, stackpointer: stackpointer, operandValue: cpu.operandType?.getOperandValue(cpu: cpu), operand: operand, operatorAddress: cpu.operatorProgramCounter, programCounter: cpu.programCounter)
    }
    
    static func testIfNoDecodeHappend(cpu: CPUCopy) -> Bool {
        cpu.`operator` == nil || cpu.operandType == nil
    }

}
