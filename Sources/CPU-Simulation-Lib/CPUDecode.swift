//
//  CPUDecode.swift
//  
//
//  Created by Paul on 10.02.22.
//

import Foundation

public func decodeInstruction(cpu: CPU) throws -> NewCPUVars {
    var tmpVars = DecodeVars(cpu: cpu)
    
    extractCodes(vars: &tmpVars)
    
    try decodeCodes(vars: &tmpVars, cpu: cpu)
    
    applyDecodedValsToNewCPUVars(vars: tmpVars)
    
    try handleOperatorRequirements(vars: tmpVars)
    
    return tmpVars.result
}

public func getOperatorOrThrowError(operatorCode: UInt8, address: UInt16) throws -> Operator {
    let assignment = CPUStandardVars.getOperatorAssignment()
    
    if !codeIsInAssignment(code: operatorCode, assignment: assignment) {
        throw CPUErrors.OperatorCodeNotDecodable(address: address, operatorCode: operatorCode)
    }
    
    return assignment[operatorCode]!()
}

public func getOperandTypeOrThrowError(operandTypeCode: UInt8, address: UInt16) throws -> AccessibleOperandType {
    let assignment = CPUStandardVars.getOperandTypeAssignment()
    
    if !codeIsInAssignment(code: operandTypeCode, assignment: assignment) {
        throw CPUErrors.OperandTypeCodeNotDecodable(address: address, operandTypeCode: operandTypeCode)
    }
    
    return assignment[operandTypeCode]!()
}

public func resolveOperand(result: NewCPUVars, cpu: CPU, operand: UInt16) {
        
    if let operandType = getOperandType(result: result, cpu: cpu) {
        let changes = operandType.resolveOperand(oldOperand: operand, cpu: cpu)
        
        applyOperandChanges(result: result, changes: changes, operandType: operandType)
        applyBusChanges(result: result, changes: changes)
        
        return
    }
    
    result.operand = operand
    return
}

private func applyOperandChanges(result: NewCPUVars, changes: OperandResolutionResult, operandType: AccessibleOperandType) {
    let result = result
    
    result.operandType = operandType
    result.operand = changes.operand
}

private func applyBusChanges(result: NewCPUVars, changes: OperandResolutionResult) {
    let result = result
    
    result.addressBus = changes.addressBus
    result.dataBus = changes.dataBus
}

private func getOperandType(result: NewCPUVars, cpu: CPU) -> AccessibleOperandType? {
    if let operandType = result.operandType {
        return operandType
    }
    
    return cpu.realOperandType
}
