//
//  FuncDecodeInternal.swift
//
//
//  Created by Paul on 17.02.22.
//

import Foundation

class DecodeInternal {

    struct DecodeVars {
        let result = NewCPUVars()
        let cpu: CPUCopy
        var opcode: UInt16 { cpu.opcode }
        var operatorCode: UInt8 = 0
        var operandTypeCode: UInt8 = 0
        var `operator`: Operator?
        var operandType: AccessibleOperandType?
        var coreOperandType: CoreOperandType? { operandType?.coreOperandType }
    }

    static func decodeCodes(vars: inout DecodeVars, cpu: CPUCopy) throws {
        vars.`operator` = try getOperatorOrThrowError(operatorCode: vars.operatorCode, address: cpu.operatorProgramCounter)
        vars.operandType = try getOperandTypeOrThrowError(operandTypeCode: vars.operandTypeCode, address: cpu.operatorProgramCounter)
    }

    static func extractCodes(vars: inout DecodeVars) {
        vars.operatorCode = getOperatorCodeFromOpcode(opcode: vars.opcode)
        vars.operandTypeCode = getOperandTypeCodeFromOpcode(opcode: vars.opcode)
    }

    static func applyDecodedValsToNewCPUVars(vars: DecodeVars) {
        vars.result.`operator` = vars.`operator`
        vars.result.operandType = vars.operandType
    }

    static func codeIsInAssignment<T>(code: UInt8, assignment: [UInt8: T]) -> Bool {
        assignment.contains { element in
            element.key == code
        }
    }

    static func getOperandTypeCodeFromOpcode(opcode: UInt16) -> UInt8 {
        UInt8(opcode >> 8)
    }

    static func getOperatorCodeFromOpcode(opcode: UInt16) -> UInt8 {
        UInt8(0xff & opcode)
    }

    static func applyOperandChanges(result: NewCPUVars, changes: OperandResolutionResult, operandType: AccessibleOperandType) {
        let result = result

        result.operandType = operandType
        result.operand = changes.operand
    }

    static func applyBusChanges(result: NewCPUVars, changes: OperandResolutionResult) {
        let result = result

        result.addressBus = changes.addressBus
        result.dataBus = changes.dataBus
    }

    static func getOperandType(result: NewCPUVars, cpu: CPUCopy) -> AccessibleOperandType? {
        if let operandType = result.operandType {
            return operandType
        }

        return cpu.realOperandType
    }
}
