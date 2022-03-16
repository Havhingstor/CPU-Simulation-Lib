//
//  FuncDecode.swift
//  
//
//  Created by Paul on 10.02.22.
//

import Foundation

private typealias Internal = DecodeInternal
private typealias DecodeVars = Internal.DecodeVars

public func decodeInstruction(cpu: CPUCopy) throws -> NewCPUVars {
    var tmpVars = DecodeVars(cpu: cpu)
    
    Internal.extractCodes(vars: &tmpVars)
    
    try Internal.decodeCodes(vars: &tmpVars, cpu: cpu)
    
    Internal.applyDecodedValsToNewCPUVars(vars: tmpVars)
    
    try DecodeConsensus.handleOperatorRequirements(vars: tmpVars)
    
    return tmpVars.result
}

public func getOperatorOrThrowError(operatorCode: UInt8, address: UInt16) throws -> Operator {
    let assignment = StandardOperators.getOperatorAssignment()
    
    if !Internal.codeIsInAssignment(code: operatorCode, assignment: assignment) {
        throw CPUSimErrors.OperatorCodeNotDecodable(address: address, operatorCode: operatorCode)
    }
    
    return assignment[operatorCode]!()
}

public func getOperandTypeOrThrowError(operandTypeCode: UInt8, address: UInt16) throws -> AccessibleOperandType {
    let assignment = StandardOperandTypes.getOperandTypeAssignment()
    
    if !Internal.codeIsInAssignment(code: operandTypeCode, assignment: assignment) {
        throw CPUSimErrors.OperandTypeCodeNotDecodable(address: address, operandTypeCode: operandTypeCode)
    }
    
    return assignment[operandTypeCode]!()
}

public func resolveOperand(result: NewCPUVars, cpu: CPUCopy, operand: UInt16) {
        
    if let operandType = Internal.getOperandType(result: result, cpu: cpu) {
        let changes = operandType.resolveOperand(oldOperand: operand, cpu: cpu)
        
        Internal.applyOperandChanges(result: result, changes: changes, operandType: operandType)
        Internal.applyBusChanges(result: result, changes: changes)
        
        if result.operand != nil {
            return
        }
    }
    
    result.operand = operand
}
