//
//  OperandTypeInternal.swift
//  
//
//  Created by Paul on 17.02.22.
//

import Foundation

class OperandTypesInternal {
    static func getOperandValueAddress(cpu: CPUCopy) -> UInt16 {
        let memory = cpu.memory
        let operand = cpu.operand
        
        return memory.read(address: operand)
    }
    
    static func getStandardOperandResolutionResult(operand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        OperandResolutionResult(operand: operand, addressBus: cpu.programCounter, dataBus: operand)
    }
    
    static func getIndirectOperandResolutionResult(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        let memory = cpu.memory
        let newOperand = memory.read(address: oldOperand)
        
        return OperandResolutionResult(operand: newOperand, addressBus: oldOperand, dataBus: newOperand)
    }
    
    static func getStackOperandResolutionResult(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        let newOperand = getOperandRelativeToStack(oldOperand: oldOperand, cpu: cpu)
        
        return OperandResolutionResult(operand: newOperand, addressBus: cpu.programCounter, dataBus: oldOperand)
    }
    
    static func getIndirectStackOperandResolutionResult(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        let tmpOperandRelToStack = getOperandRelativeToStack(oldOperand: oldOperand, cpu: cpu)
        
        return getIndirectOperandResolutionResult(oldOperand: tmpOperandRelToStack, cpu: cpu)
    }
    
    static func getLiteralStackOperandResolutionResult(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        let tmpOperandRelToStack = getOperandRelativeToStack(oldOperand: oldOperand, cpu: cpu)
        
        return getStandardOperandResolutionResult(operand: tmpOperandRelToStack, cpu: cpu)
    }
    
    private static func getOperandRelativeToStack(oldOperand: UInt16, cpu: CPUCopy) -> UInt16 {
        let stackpointer = cpu.stackpointer
        return stackpointer &+ oldOperand
    }
}
