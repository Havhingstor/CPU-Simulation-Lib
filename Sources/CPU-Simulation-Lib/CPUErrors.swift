//
//  CPUErrors.swift
//  
//
//  Created by Paul on 12.02.22.
//

import Foundation

public enum CPUErrors: Error, Equatable {
    case OperatorCodeNotDecodable(address: UInt16, operatorCode: UInt8)
    case OperandTypeCodeNotDecodable(address: UInt16, operandTypeCode: UInt8)
    
    case OperatorRequiresInstantLiteralOperandAccess(address: UInt16, operatorCode: UInt8, operandTypeCode: UInt8)
    case OperatorAllowsNoOperand(address: UInt16, operatorCode: UInt8, operandTypeCode: UInt8)
    case OperatorRequiresAddressOrWriteAccess(address: UInt16, operatorCode: UInt8, operandTypeCode: UInt8)
    case OperatorRequiresExistingOperand(address: UInt16, operatorCode: UInt8, operandTypeCode: UInt8)
}
