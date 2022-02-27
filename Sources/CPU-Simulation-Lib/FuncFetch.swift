//
//  FuncFetch.swift
//  
//
//  Created by Paul on 12.02.22.
//

import Foundation

private typealias Internal = FetchInternal

public func fetchOpcode(cpu: CPUCopy) -> NewCPUVars {
    let memory = cpu.memory
    let result = NewCPUVars()
    
    Internal.readOpcode(dest: result, programCounter: cpu.programCounter, memory: memory)
    
    Internal.setAddressBus(dest: result, programCounter: cpu.programCounter)
    Internal.setDataBusOperator(dest: result)
    
    return result
}

public func fetchOperand(cpu: CPUCopy) -> NewCPUVars {
    let memory = cpu.memory
    let result = NewCPUVars()
    
    let operand = Internal.readOperand(dest: result, programCounter: cpu.programCounter, memory: memory)
    
    resolveOperand(result: result, cpu: cpu, operand: operand)
    
    return result
}
