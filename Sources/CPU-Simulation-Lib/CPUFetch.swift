//
//  CPUFetch.swift
//  
//
//  Created by Paul on 12.02.22.
//

import Foundation

public func fetchOperator(cpu: CPU) -> NewCPUVars {
    let memory = cpu.memory
    var result = NewCPUVars()
    
    readOpcode(dest: &result, programCounter: cpu.programCounter, memory: memory)
    
    setAddressBus(dest: &result, programCounter: cpu.programCounter)
    setDataBusOperator(dest: &result)
    
    return result
}

public func fetchOperand(cpu: CPU) -> NewCPUVars {
    let memory = cpu.memory
    var result = NewCPUVars()
    
    readOperand(dest: &result, programCounter: cpu.programCounter, memory: memory)
    
    setAddressBus(dest: &result, programCounter: cpu.programCounter)
    setDataBusOperand(dest: &result)
    
    return result
}

private func readOpcode(dest: inout NewCPUVars, programCounter: UInt16, memory: Memory) {
    dest.opcode = memory.read(address: programCounter)
}

private func readOperand(dest: inout NewCPUVars, programCounter: UInt16, memory: Memory) {
    dest.operand = memory.read(address: programCounter)
}

private func setAddressBus(dest: inout NewCPUVars, programCounter: UInt16) {
    dest.addressBus = programCounter
}

private func setDataBusOperator(dest: inout NewCPUVars) {
    dest.dataBus = dest.opcode
}

private func setDataBusOperand(dest: inout NewCPUVars) {
    dest.dataBus = dest.operand
}
