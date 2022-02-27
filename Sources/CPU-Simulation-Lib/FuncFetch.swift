//
//  FuncFetch.swift
//  
//
//  Created by Paul on 12.02.22.
//

import Foundation

public func fetchOpcode(cpu: CPUCopy) -> NewCPUVars {
    let memory = cpu.memory
    let result = NewCPUVars()
    
    readOpcode(dest: result, programCounter: cpu.programCounter, memory: memory)
    
    setAddressBus(dest: result, programCounter: cpu.programCounter)
    setDataBusOperator(dest: result)
    
    return result
}

public func fetchOperand(cpu: CPUCopy) -> NewCPUVars {
    let memory = cpu.memory
    let result = NewCPUVars()
    
    let operand = readOperand(dest: result, programCounter: cpu.programCounter, memory: memory)
    
    resolveOperand(result: result, cpu: cpu, operand: operand)
    
    return result
}

private func readOpcode(dest: NewCPUVars, programCounter: UInt16, memory: Memory) {
    dest.opcode = memory.read(address: programCounter)
}

private func readOperand(dest: NewCPUVars, programCounter: UInt16, memory: Memory) -> UInt16{
    memory.read(address: programCounter)
}

private func setAddressBus(dest: NewCPUVars, programCounter: UInt16) {
    dest.addressBus = programCounter
}

private func setDataBusOperator(dest: NewCPUVars) {
    dest.dataBus = dest.opcode
}
