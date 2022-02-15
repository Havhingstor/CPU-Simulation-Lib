//
//  OperandType.swift
//  
//
//  Created by Paul on 14.02.22.
//

import Foundation

public protocol OperandType {
    static var operandCode: UInt8 { get }
    static var providesWriteAccess: Bool { get }
    static var readAccess: ReadAccess { get }
    
    init()
}

extension OperandType {
    public var operandCode: UInt8 { Self.operandCode }
    public var operandCodePreparedForOpcode: UInt16 { UInt16(operandCode) << 8}
    public var isNothing: Bool { !providesWriteAccess && Self.readAccess == .none}
    public var providesInstantLiteral: Bool { Self.readAccess == .instantLiteralRead }
    public var providesWriteAccess: Bool { Self.providesWriteAccess }
}

public enum ReadAccess {
    case none
    case read
    case instantLiteralRead
}
