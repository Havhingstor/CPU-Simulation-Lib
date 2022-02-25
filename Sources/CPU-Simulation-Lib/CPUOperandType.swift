//
//  CPUOperandType.swift
//  
//
//  Created by Paul on 14.02.22.
//

import Foundation
import CPU_Simulation_Utilities

public protocol AccessibleOperandType {
    typealias Builder = StandardNextValueProvider<CoreOperandType>.Builder
    
    static var operandTypeCode: UInt8 { get }
    static var standardCoreOperandTypeProvider: StandardNextValueProvider<CoreOperandType> { get }
    var id: UUID { get }
    
    func resolveOperand(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult
    
    init()
}

extension AccessibleOperandType {
    public var operandTypeCode: UInt8 { Self.operandTypeCode }
    public var operandTypeCodePreparedForOpcode: UInt16 { UInt16(operandTypeCode) << 8}
    
    public var coreOperandType: CoreOperandType { Self.standardCoreOperandTypeProvider.getNextValue(uuid: id)() }
    
    public static var standardCoreOperandType: Builder {
        get {
            standardCoreOperandTypeProvider.standardNextValue
        }
        set(standardCoreOperandType) {
            standardCoreOperandTypeProvider.standardNextValue = standardCoreOperandType
        }
    }
    
    public static func resetStandardCoreOperandType() {
        standardCoreOperandTypeProvider.resetStandardNextValue()
    }
}

public protocol CoreOperandType: AccessibleOperandType {
    static var providesAddressOrWriteAccess: Bool { get }
    static var readAccess: ReadAccess { get }
    
    func getOperandValue(cpu: CPUCopy) -> UInt16?
}

extension CoreOperandType {
    public var isNothing: Bool { !providesAddressOrWriteAccess && Self.readAccess == .none}
    public var providesInstantLiteral: Bool { Self.readAccess == .instantLiteralRead }
    public var providesAddressOrWriteAccess: Bool { Self.providesAddressOrWriteAccess }
    
    public static var standardCoreOperandTypeProvider: StandardNextValueProvider<CoreOperandType> { StandardNextValueProvider(builder: Self.init)}
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
