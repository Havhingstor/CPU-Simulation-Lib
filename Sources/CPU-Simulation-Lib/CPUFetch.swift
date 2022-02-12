//
//  CPUFetch.swift
//  
//
//  Created by Paul on 12.02.22.
//

import Foundation

public func fetchInstruction(cpu: CPU) -> NewCPUVars {
    let memory = cpu.memory
    var result = NewCPUVars()
    
    readOpcode(dest: &result, programCounter: cpu.programCounter, memory: memory)
    readReferencedAddress(dest: &result, programCounter: cpu.programCounter, memory: memory)
    
    setAddressBus(dest: &result, programCounter: cpu.programCounter)
    setDataBus(dest: &result)
    
    return result
}

private func readOpcode(dest: inout NewCPUVars, programCounter: UInt16, memory: Memory) {
    dest.opcode = memory.read(address: programCounter)
}

private func readReferencedAddress(dest: inout NewCPUVars, programCounter: UInt16, memory: Memory) {
    dest.referencedAddress = memory.read(address: getAddressOfReferencedAddress(programCounter: programCounter))
}

private func setAddressBus(dest: inout NewCPUVars, programCounter: UInt16) {
    dest.addressBus = getAddressOfReferencedAddress(programCounter: programCounter)
}

private func setDataBus(dest: inout NewCPUVars) {
    dest.dataBus = dest.referencedAddress
}

private func getAddressOfReferencedAddress(programCounter: UInt16) -> UInt16 {
    programCounter &+ 1
}