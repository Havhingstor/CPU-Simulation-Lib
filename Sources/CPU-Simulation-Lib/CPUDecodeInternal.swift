//
//  CPUDecodeInternal.swift
//  
//
//  Created by Paul on 17.02.22.
//

import Foundation

struct DecodeVars {
    var result = NewCPUVars()
    var cpu: CPU
    var opcode: UInt16 { cpu.opcode }
    var operatorCode: UInt8 = 0
    var operandTypeCode: UInt8 = 0
    var currentOperator: Operator?
    var operandType: OperandType?
}

func decodeCodes(vars: DecodeVars, cpu: CPU) throws -> DecodeVars {
    var result = vars
    
    result.currentOperator = try getOperatorOrThrowError(operatorCode: result.operatorCode, address: cpu.operatorProgramCounter)
    result.operandType = try getOperandTypeOrThrowError(operandTypeCode: result.operandTypeCode, address: cpu.operatorProgramCounter)
    
    return result
}

func extractCodes(vars: DecodeVars) -> DecodeVars {
    var result = vars
    
    result.operatorCode = getOperatorCodeFromOpcode(opcode: vars.opcode)
    result.operandTypeCode = getOperandTypeCodeFromOpcode(opcode: vars.opcode)
    
    return result
}

func applyDecodedValsToNewCPUVars(vars: DecodeVars) -> DecodeVars {
    let result = vars
    
    result.result.currentOperator = result.currentOperator
    result.result.operandType = result.operandType
    
    return result
}

func codeIsInAssignment<T>(code: UInt8, assignment: [UInt8 : T]) -> Bool {
    assignment.contains { element in
        element.key == code
    }
}

func getOperandTypeCodeFromOpcode(opcode: UInt16) -> UInt8 {
    UInt8( opcode >> 8)
}

func getOperatorCodeFromOpcode(opcode: UInt16) -> UInt8 {
    UInt8(0xff & opcode)
}
