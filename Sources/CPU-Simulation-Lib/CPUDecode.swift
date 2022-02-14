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
    let addressCode = getAddressCodeFromOpcode(opcode: cpu.opcode)
    
    let op = getOperator(operatorCode: operatorCode)
    let addressType = getAddressType(addressCode: addressCode)
    
    if let op = op  {
        if let addressType = addressType {
            result.currentOperator = op
            result.addressType = addressType
        } else {
            throw CPUErrors.AddressCodeNotDecodable(address: cpu.lastProgramCounter, addressCode: addressCode)
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

public func getAddressType(addressCode: UInt8) -> AddressType? {
    let assignment = CPUStandardVars.getAddressTypeAssignment()
    
    return assignment[addressCode]?()
}

private func getAddressCodeFromOpcode(opcode: UInt16) -> UInt8 {
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
