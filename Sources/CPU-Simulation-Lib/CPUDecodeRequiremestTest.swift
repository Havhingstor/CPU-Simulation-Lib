//
//  CPUDecodeRequiremestTest.swift
//  
//
//  Created by Paul on 17.02.22.
//

import Foundation

func handleOperatorRequirements(vars: DecodeVars) throws {
    try handleRequiredLiteral(vars: vars)
    try handleNotAllowedOperand(vars: vars)
    try handleRequiredAddressOrWriteAccess(vars: vars)
    try handleRequiredOperand(vars: vars)
}

func handleRequiredLiteral(vars: DecodeVars) throws {
    if testForRequiredLiteral(vars: vars) {
        try throwLiteralRequiredError(vars: vars)
    }
}

func handleNotAllowedOperand(vars: DecodeVars) throws {
    if testForNoAllowedOperand(vars: vars) {
        try throwOperatorAllowsNoOperandError(vars: vars)
    }
}

func handleRequiredAddressOrWriteAccess(vars: DecodeVars) throws {
    if testForRequiredAddressOrWriteAccess(vars: vars) {
        try throwAddressOrWriteAccessRequiredError(vars: vars)
    }
}

func handleRequiredOperand(vars: DecodeVars) throws {
    if testForNeededOperand(vars: vars) {
        try throwOperandAccessNeededError(vars: vars)
    }
}

func testForRequiredLiteral(vars: DecodeVars) -> Bool {
    vars.currentOperator!.requiresLiteralReadAccess && !vars.coreOperandType!.providesInstantLiteral
}

func testForNoAllowedOperand(vars: DecodeVars) -> Bool {
    vars.currentOperator!.allowsNoOperand && !vars.coreOperandType!.isNothing
}

func testForRequiredAddressOrWriteAccess(vars: DecodeVars) -> Bool {
    vars.currentOperator!.requiresAddressOrWriteAccess && !vars.coreOperandType!.providesAddressOrWriteAccess
}

func testForNeededOperand(vars: DecodeVars) -> Bool {
    !vars.currentOperator!.allowsNoOperand && vars.coreOperandType!.isNothing
}

func throwLiteralRequiredError(vars: DecodeVars) throws {
    throw CPUErrors.OperatorRequiresInstantLiteralOperandAccess(address: vars.cpu.operatorProgramCounter, operatorCode: vars.operatorCode, operandTypeCode: vars.operandTypeCode)
}

func throwOperatorAllowsNoOperandError(vars: DecodeVars) throws {
    throw CPUErrors.OperatorAllowsNoOperand(address: vars.cpu.operatorProgramCounter, operatorCode: vars.operatorCode, operandTypeCode: vars.operandTypeCode)
}

func throwAddressOrWriteAccessRequiredError(vars: DecodeVars) throws {
    throw CPUErrors.OperatorRequiresAddressOrWriteAccess(address: vars.cpu.operatorProgramCounter, operatorCode: vars.operatorCode, operandTypeCode: vars.operandTypeCode)
}

func throwOperandAccessNeededError(vars: DecodeVars) throws {
    throw CPUErrors.OperatorRequiresExistingOperand(address: vars.cpu.operatorProgramCounter, operatorCode: vars.operatorCode, operandTypeCode: vars.operandTypeCode)
}
