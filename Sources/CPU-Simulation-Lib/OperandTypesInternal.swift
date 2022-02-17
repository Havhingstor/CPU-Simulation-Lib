//
//  OperandTypesInternal.swift
//  
//
//  Created by Paul on 17.02.22.
//

import Foundation

class OperandTypesInternal {
    static func getOperandValueAddress(cpu: CPU) -> UInt16 {
        let memory = cpu.memory
        let operand = cpu.operand
        
        return memory.read(address: operand)
    }
    
    static func getIndirectOperandValueAddress(cpu: CPU) -> UInt16 {
        let memory = cpu.memory
        
        return memory.read(address: getOperandValueAddress(cpu: cpu))
    }
    
    static func getOperandValueRelToStackpointer(cpu: CPU) -> UInt16 {
        let memory = cpu.memory
        
        return memory.read(address: getOperandInRelationToStackpointer(cpu: cpu))
    }
    
    static func getIndirectOperandValueRelToStackpointer(cpu: CPU) -> UInt16 {
        let memory = cpu.memory
        
        return memory.read(address: getOperandValueRelToStackpointer(cpu: cpu))
    }
    
    static func getOperandInRelationToStackpointer(cpu: CPU) -> UInt16 {
        let stackpointer = cpu.stackpointer
        let operand = cpu.operand
        
        return stackpointer &+ operand
    }
}
