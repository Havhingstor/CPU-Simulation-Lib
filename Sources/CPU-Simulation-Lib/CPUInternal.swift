//
//  CPUInternal.swift
//  
//
//  Created by Paul on 10.02.22.
//

import Foundation

public func fetchInstruction(cpu: CPU) -> NewCPUVars {
    let memory = cpu.memory
    var result = NewCPUVars()
    
    readOpcode(dest: &result, pc: cpu.programCounter, memory: memory)
    readReferencedAddress(dest: &result, pc: cpu.programCounter, memory: memory)
    
    setAddressBus(dest: &result, pc: cpu.programCounter)
    setDataBus(dest: &result)
    
    return result
}

public func resetBusses(dest: inout NewCPUVars) {
    resetAddressBus(dest: &dest)
    resetDataBus(dest: &dest)
}

private func resetAddressBus(dest: inout NewCPUVars) {
    dest.addressBus = 0
}

private func resetDataBus(dest: inout NewCPUVars) {
    dest.dataBus = 0
}

private func readOpcode(dest: inout NewCPUVars, pc: UInt16, memory: Memory) {
    dest.opcode = memory.read(address: pc)
}

private func readReferencedAddress(dest: inout NewCPUVars, pc: UInt16, memory: Memory) {
    dest.referencedAddress = memory.read(address: getAddressOfReferencedAddress(pc: pc))
}

private func setAddressBus(dest: inout NewCPUVars, pc: UInt16) {
    dest.addressBus = getAddressOfReferencedAddress(pc: pc)
}

private func setDataBus(dest: inout NewCPUVars) {
    dest.dataBus = dest.referencedAddress
}

private func getAddressOfReferencedAddress(pc: UInt16) -> UInt16 {
    pc &+ 1
}
