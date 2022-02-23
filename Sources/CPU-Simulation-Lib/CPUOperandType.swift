//
//  CPUOperandType.swift
//  
//
//  Created by Paul on 14.02.22.
//

import Foundation

public protocol AccessibleOperandType {
    static var operandTypeCode: UInt8 { get }
    var coreOperandType: CoreOperandType { get }
    
    func resolveOperand(oldOperand: UInt16, cpu: CPU) -> OperandResolutionResult
    
    init()
}

extension AccessibleOperandType {
    public var operandTypeCode: UInt8 { Self.operandTypeCode }
    public var operandTypeCodePreparedForOpcode: UInt16 { UInt16(operandTypeCode) << 8}
}

public protocol CoreOperandType: AccessibleOperandType {
    static var providesAddressOrWriteAccess: Bool { get }
    static var readAccess: ReadAccess { get }
    
    func getOperandValue(cpu: CPU) -> UInt16?
}

extension CoreOperandType {
    public var isNothing: Bool { !providesAddressOrWriteAccess && Self.readAccess == .none}
    public var providesInstantLiteral: Bool { Self.readAccess == .instantLiteralRead }
    public var providesAddressOrWriteAccess: Bool { Self.providesAddressOrWriteAccess }
    
    public var coreOperandType: CoreOperandType { self as CoreOperandType }
}

public enum ReadAccess {
    case none
    case read
    case instantLiteralRead
}

public struct OperandResolutionResult {
    let operand: UInt16?
    let addressBus: UInt16?
    let dataBus: UInt16?
    
    public init(operand: UInt16?, addressBus: UInt16?, dataBus: UInt16?) {
        self.operand = operand
        self.addressBus = addressBus
        self.dataBus = dataBus
    }
}
