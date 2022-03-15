//
//  CPUOperationVars.swift
//  
//
//  Created by Paul on 10.02.22.
//

import Foundation

class CPUOperationVars {
    var programCounter: UInt16 = 0
    var state: CPUState = StandardStates.startingState()
    var opcode: UInt16 = 0
    var operand: UInt16 = 0
    var `operator`: Operator?
    var operatorProgramCounter: UInt16 = 0
    var realOperandType: AccessibleOperandType?
    var operandType: CoreOperandType? { realOperandType?.coreOperandType }
    
    func operateNextStep(parent: CPUCopy) throws -> NewCPUVars {
        state = state.nextState()
        
        let newVars = try state.operate(cpu: parent)
        
        return newVars
    }
    
    func applyNewCPUVars(vars: NewCPUVars) {
        saveProgramCounterIfUsedForOperator(opcode: vars.opcode)
        applyProgramCounter(programCounter: vars.programCounter)
        applyOpcode(opcode: vars.opcode)
        applyOperand(operand: vars.operand)
        applyOperator(operator: vars.`operator`)
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
    private func applyOperator(`operator`: Operator?) {
        if let `operator` = `operator` {
            self.`operator` = `operator`
        }
    }
    private func applyOperandType(operandType: AccessibleOperandType?) {
        if let operandType = operandType {
            self.realOperandType = operandType
        }
    }
}
