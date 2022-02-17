//
//  OperandType.swift
//  
//
//  Created by Paul on 14.02.22.
//

import Foundation

public protocol OperandType {
    static var operandTypeCode: UInt8 { get }
    static var providesAddressOrWriteAccess: Bool { get }
    static var readAccess: ReadAccess { get }
    
    init()
}

extension OperandType {
    public var operandTypeCode: UInt8 { Self.operandTypeCode }
    public var operandTypeCodePreparedForOpcode: UInt16 { UInt16(operandTypeCode) << 8}
    public var isNothing: Bool { !providesAddressOrWriteAccess && Self.readAccess == .none}
    public var providesInstantLiteral: Bool { Self.readAccess == .instantLiteralRead }
    public var providesAddressOrWriteAccess: Bool { Self.providesAddressOrWriteAccess }
}

public enum ReadAccess {
    case none
    case read
    case instantLiteralRead
}
