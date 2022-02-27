//
//  FuncDecodeInternal.swift
//  
//
//  Created by Paul on 17.02.22.
//

import Foundation

struct DecodeVars {
    let result = NewCPUVars()
    let cpu: CPUCopy
    var opcode: UInt16 { cpu.opcode }
    var operatorCode: UInt8 = 0
    var operandTypeCode: UInt8 = 0
    var currentOperator: Operator?
    var operandType: AccessibleOperandType?
    var coreOperandType: CoreOperandType? { operandType?.coreOperandType }
}

func decodeCodes(vars: inout DecodeVars, cpu: CPUCopy) throws {
    vars.currentOperator = try getOperatorOrThrowError(operatorCode: vars.operatorCode, address: cpu.operatorProgramCounter)
    vars.operandType = try getOperandTypeOrThrowError(operandTypeCode: vars.operandTypeCode, address: cpu.operatorProgramCounter)
}

func extractCodes(vars: inout DecodeVars) {
    vars.operatorCode = getOperatorCodeFromOpcode(opcode: vars.opcode)
    vars.operandTypeCode = getOperandTypeCodeFromOpcode(opcode: vars.opcode)
}

func applyDecodedValsToNewCPUVars(vars: DecodeVars) {
    vars.result.currentOperator = vars.currentOperator
    vars.result.operandType = vars.operandType
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
