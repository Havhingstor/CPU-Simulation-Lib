//
//  CPUStandardOperandTypes.swift
//  
//
//  Created by Paul on 14.02.22.
//

import Foundation

open class AddressOperandType: OperandType {
    public static var providesWriteAccess: Bool { true }
    
    public static var readAccess: ReadAccess { .read }
    
    open class var operandCode: UInt8 { 1 }
    
    public required init() {}
}

open class LiteralOperandType: OperandType {
    public static var providesWriteAccess: Bool { false }
    
    public static var readAccess: ReadAccess { .instantLiteralRead }
    
    open class var operandCode: UInt8 { 2 }
    
    public required init() {}
}

open class IndirectAddressOperandType: OperandType {
    public static var providesWriteAccess: Bool { true }
    
    public static var readAccess: ReadAccess { .read }
    
    open class var operandCode: UInt8 { 3 }
    
    public required init() {}
}

open class StackOperandType: OperandType {
    public static var providesWriteAccess: Bool { true }
    
    public static var readAccess: ReadAccess { .read }
    
    open class var operandCode: UInt8 { 4 }
    
    public required init() {}
}

open class IndirectStackOperandType: OperandType {
    public static var providesWriteAccess: Bool { true }
    
    public static var readAccess: ReadAccess { .read }
    
    open class var operandCode: UInt8 { 5 }
    
    public required init() {}
}

open class LiteralStackOperandType: OperandType {
    public static var providesWriteAccess: Bool { false }
    
    public static var readAccess: ReadAccess { .read }
    
    open class var operandCode: UInt8 { 6 }
    
    public required init() {}
}

open class NoneOperandType: OperandType {
    public static var providesWriteAccess: Bool { false }
    
    public static var readAccess: ReadAccess { .none }
    
    open class var operandCode: UInt8 { 0 }
    
    public required init() {}
}

extension CPUStandardVars {
    public static var standardOperandTypes: [operandTypeInit] { [
        AddressOperandType.init,
        LiteralOperandType.init,
        IndirectAddressOperandType.init,
        StackOperandType.init,
        IndirectStackOperandType.init,
        LiteralStackOperandType.init,
        NoneOperandType.init,
    ]}
}
