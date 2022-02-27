//
//  FuncDecodeConsensus.swift
//
//
//  Created by Paul on 17.02.22.
//

import Foundation

class DecodeConsensus {
    
    typealias Internal = DecodeInternal
    typealias DecodeVars = Internal.DecodeVars

    static func handleOperatorRequirements(vars: DecodeVars) throws {
        try handleRequiredLiteral(vars: vars)
        try handleNotAllowedOperand(vars: vars)
        try handleRequiredAddressOrWriteAccess(vars: vars)
        try handleRequiredOperand(vars: vars)
    }

    static func handleRequiredLiteral(vars: DecodeVars) throws {
        if testForRequiredLiteral(vars: vars) {
            try throwLiteralRequiredError(vars: vars)
        }
    }

    static func handleNotAllowedOperand(vars: DecodeVars) throws {
        if testForNoAllowedOperand(vars: vars) {
            try throwOperatorAllowsNoOperandError(vars: vars)
        }
    }

    static func handleRequiredAddressOrWriteAccess(vars: DecodeVars) throws {
        if testForRequiredAddressOrWriteAccess(vars: vars) {
            try throwAddressOrWriteAccessRequiredError(vars: vars)
        }
    }

    static func handleRequiredOperand(vars: DecodeVars) throws {
        if testForNeededOperand(vars: vars) {
            try throwOperandAccessNeededError(vars: vars)
        }
    }

    static func testForRequiredLiteral(vars: DecodeVars) -> Bool {
        vars.currentOperator!.requiresLiteralReadAccess && !vars.coreOperandType!.providesInstantLiteral
    }

    static func testForNoAllowedOperand(vars: DecodeVars) -> Bool {
        vars.currentOperator!.allowsNoOperand && !vars.coreOperandType!.isNothing
    }

    static func testForRequiredAddressOrWriteAccess(vars: DecodeVars) -> Bool {
        vars.currentOperator!.requiresAddressOrWriteAccess && !vars.coreOperandType!.providesAddressOrWriteAccess
    }

    static func testForNeededOperand(vars: DecodeVars) -> Bool {
        !vars.currentOperator!.allowsNoOperand && vars.coreOperandType!.isNothing
    }

    static func throwLiteralRequiredError(vars: DecodeVars) throws {
        throw CPUSimErrors.OperatorRequiresInstantLiteralOperandAccess(address: vars.cpu.operatorProgramCounter, operatorCode: vars.operatorCode, operandTypeCode: vars.operandTypeCode)
    }

    static func throwOperatorAllowsNoOperandError(vars: DecodeVars) throws {
        throw CPUSimErrors.OperatorAllowsNoOperand(address: vars.cpu.operatorProgramCounter, operatorCode: vars.operatorCode, operandTypeCode: vars.operandTypeCode)
    }

    static func throwAddressOrWriteAccessRequiredError(vars: DecodeVars) throws {
        throw CPUSimErrors.OperatorRequiresAddressOrWriteAccess(address: vars.cpu.operatorProgramCounter, operatorCode: vars.operatorCode, operandTypeCode: vars.operandTypeCode)
    }

    static func throwOperandAccessNeededError(vars: DecodeVars) throws {
        throw CPUSimErrors.OperatorRequiresExistingOperand(address: vars.cpu.operatorProgramCounter, operatorCode: vars.operatorCode, operandTypeCode: vars.operandTypeCode)
    }

}
