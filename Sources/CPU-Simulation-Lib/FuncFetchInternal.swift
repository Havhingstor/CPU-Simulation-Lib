//
//  FuncFetchInternal.swift
//  
//
//  Created by Paul on 27.02.22.
//

import Foundation

class FetchInternal {
    
    static func readOpcode(dest: NewCPUVars, programCounter: UInt16, memory: Memory) {
        dest.opcode = memory.read(address: programCounter)
    }
    
    static func readOperand(dest: NewCPUVars, programCounter: UInt16, memory: Memory) -> UInt16{
        memory.read(address: programCounter)
    }
    
    static func setAddressBus(dest: NewCPUVars, programCounter: UInt16) {
        dest.addressBus = programCounter
    }
    
    static func setDataBusOperator(dest: NewCPUVars) {
        dest.dataBus = dest.opcode
    }

}
