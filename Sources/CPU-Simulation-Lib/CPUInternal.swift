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
    
    return result
}

private func readOpcode(dest: inout NewCPUVars, pc: UInt16, memory: Memory) {
    dest.opcode = memory.read(address: pc)
}

private func readReferencedAddress(dest: inout NewCPUVars, pc: UInt16, memory: Memory) {
    dest.referencedAddress = memory.read(address: pc &+ 1)
}
