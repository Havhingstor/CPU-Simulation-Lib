//
//  CPUExecutor.swift
//  
//
//  Created by Paul on 10.02.22.
//

import Foundation

class CPUExecutor {
    var programCounter: UInt16 = 0
    var state: CPUState = CPUStandardVars.startingState.generate()
    var opcode: UInt16 = 0
    var operand: UInt16 = 0
    var currentOperator: Operator?
    var operatorProgramCounter: UInt16 = 0
    var operandType: OperandType?
    
    func executeNextStep(parent: CPU) throws -> NewCPUVars {
        let newVars = try state.operate(cpu: parent)
        
        state = state.nextState.generate()
        
        return newVars
    }
    
    func applyNewCPUVars(vars: NewCPUVars) {
        saveProgramCounterIfUsedForOperator(opcode: vars.opcode)
        applyProgramCounter(programCounter: vars.programCounter)
        applyOpcode(opcode: vars.opcode)
        applyOperand(operand: vars.operand)
        applyOperator(currentOperator: vars.currentOperator)
        applyOperandType(operandType: vars.operandType)
    }
    
    private func saveProgramCounterIfUsedForOperator(opcode: UInt16?) {
        if opcode != nil {
            operatorProgramCounter = programCounter
        }
    }
    
    private func applyProgramCounter(programCounter: UInt16?) {
        if let programCounter = programCounter {
            self.programCounter = programCounter
        }
    }
    
    private func applyOpcode(opcode: UInt16?) {
        if let opcode = opcode {
            self.opcode = opcode
        }
    }
    
    private func applyOperand(operand: UInt16?) {
        if let operand = operand {
            self.operand = operand
        }
    }
    private func applyOperator(currentOperator: Operator?) {
        if let currentOperator = currentOperator {
            self.currentOperator = currentOperator
        }
    }
    private func applyOperandType(operandType: OperandType?) {
        if let operandType = operandType {
            self.operandType = operandType
        }
    }
}
