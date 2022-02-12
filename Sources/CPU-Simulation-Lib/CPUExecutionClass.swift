//
//  CPUExecutionClass.swift
//  
//
//  Created by Paul on 10.02.22.
//

import Foundation

class CPUExecution {
    var programCounter: UInt16 = 0
    var state: CPUState = CPUStandardVars.startingState.generate()
    var opcode: UInt16 = 0
    var referencedAddress: UInt16 = 0
    var currentOperator: Operator = NOOPOperator()
    var lastProgramCounter: UInt16 = 0
    
    func executeNextStep(parent: CPU) throws -> NewCPUVars {
        let newVars = try state.operate(cpu: parent)
        
        state = state.nextState.generate()
        
        return newVars
    }
    
    func applyNewCPUVars(vars: NewCPUVars) {
        applyProgramCounter(programCounter: vars.programCounter)
        applyOpcode(opcode: vars.opcode)
        applyReferencedAddress(referencedAddress: vars.referencedAddress)
        applyOperator(currentOperator: vars.currentOperator)
    }
    
    private func applyProgramCounter(programCounter: UInt16?) {
        if let programCounter = programCounter {
            lastProgramCounter = self.programCounter
            self.programCounter = programCounter
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
    private func applyOperator(currentOperator: Operator?) {
        if let currentOperator = currentOperator {
            self.currentOperator = currentOperator
        }
    }
}
