//
//  CPUExecution.swift
//  
//
//  Created by Paul on 10.02.22.
//

import Foundation

class CPUExecution {
    var programCounter: UInt16 = 0
    var state: CPUState = CPU.startingState.generate()
    var opcode: UInt16 = 0
    var referencedAddress: UInt16 = 0
    
    func executeNextStep(parent: CPU) -> NewCPUVars {
        let newVars = state.operate(cpu: parent)
        
        state = state.nextState.generate()
        
        return newVars
    }
    
    func applyNewCPUVars(vars: NewCPUVars) {
        applyProgramCounter(pc: vars.programCounter)
        applyOpcode(opcode: vars.opcode)
        applyReferencedAddress(referencedAddress: vars.referencedAddress)
    }
    
    private func applyProgramCounter(pc: UInt16?) {
        if let pc = pc {
            programCounter = pc
        }
    }
    
    private func applyOpcode(opcode: UInt16?) {
        if let opcode = opcode {
            self.opcode = opcode
        }
    }
    
    private func applyReferencedAddress(referencedAddress: UInt16?) {
        if let referencedAddress = referencedAddress {
            self.referencedAddress = referencedAddress
        }
    }
}
