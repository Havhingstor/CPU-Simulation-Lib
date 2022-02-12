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
    if let op = getOperator(operatorCode: operatorCode) {
        result.currentOperator = op
    } else {
        throw CPUErrors.OperatorCodeNotDecodable(address: cpu.lastProgramCounter, operatorCode: operatorCode)
    }
    
    return result
}

public func getOperator(operatorCode: UInt8) -> Operator? {
    let assignment = CPUStandardVars.getOperatorAssignment()
    
    return assignment[operatorCode]?()
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
