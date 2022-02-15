//
//  CPUDecode.swift
//  
//
//  Created by Paul on 10.02.22.
//

import Foundation

public func decodeInstruction(cpu: CPU) throws -> NewCPUVars {
    var result = NewCPUVars()
    
    resetBusses(dest: &result)
    
    let operatorCode = getOperatorCodeFromOpcode(opcode: cpu.opcode)
    let operandCode = getOperandCodeFromOpcode(opcode: cpu.opcode)
    
    let op = getOperator(operatorCode: operatorCode)
    let operandType = getOperandType(operandCode: operandCode)
    
    if let op = op  {
        if let operandType = operandType {
            result.currentOperator = op
            result.operandType = operandType
        } else {
            throw CPUErrors.OperandCodeNotDecodable(address: cpu.lastProgramCounter, operandCode: operandCode)
        }
    } else {
        throw CPUErrors.OperatorCodeNotDecodable(address: cpu.lastProgramCounter, operatorCode: operatorCode)
    }
    
    return result
}

public func getOperator(operatorCode: UInt8) -> Operator? {
    let assignment = CPUStandardVars.getOperatorAssignment()
    
    return assignment[operatorCode]?()
}

public func getOperandType(operandCode: UInt8) -> OperandType? {
    let assignment = CPUStandardVars.getOperandTypeAssignment()
    
    return assignment[operandCode]?()
}

private func getOperandCodeFromOpcode(opcode: UInt16) -> UInt8 {
    UInt8( opcode >> 8)
}

private func getOperatorCodeFromOpcode(opcode: UInt16) -> UInt8 {
    UInt8(0xff & opcode)
}

private func resetBusses(dest: inout NewCPUVars) {
    resetAddressBus(dest: &dest)
    resetDataBus(dest: &dest)
}

private func resetAddressBus(dest: inout NewCPUVars) {
    dest.addressBus = 0
}

private func resetDataBus(dest: inout NewCPUVars) {
    dest.dataBus = 0
}
