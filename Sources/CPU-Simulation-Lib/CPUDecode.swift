//
//  CPUDecode.swift
//  
//
//  Created by Paul on 10.02.22.
//

import Foundation

public func decodeInstruction(cpu: CPU) throws -> NewCPUVars {
    var tmpVars = DecodeVars(cpu: cpu)
    
    tmpVars = resetBusses(dest: tmpVars)
    
    tmpVars = extractCodes(vars: tmpVars)
    
    tmpVars = try decodeCodes(vars: tmpVars, cpu: cpu)
    
    tmpVars = applyDecodedValsToNewCPUVars(vars: tmpVars)
    
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

public func getOperandTypeOrThrowError(operandTypeCode: UInt8, address: UInt16) throws -> OperandType {
    let assignment = CPUStandardVars.getOperandTypeAssignment()
    
    if !codeIsInAssignment(code: operandTypeCode, assignment: assignment) {
        throw CPUErrors.OperandTypeCodeNotDecodable(address: address, operandTypeCode: operandTypeCode)
    }
    
    return assignment[operandTypeCode]!()
}
