//
//  CPUStandardAddressTypes.swift
//  
//
//  Created by Paul on 14.02.22.
//

import Foundation

open class AddressAddressType: AddressType {
    public static var providesWriteAccess: Bool { true }
    
    public static var readAccess: ReadAccess { .read }
    
    open class var addressCode: UInt8 { 1 }
    
    public required init() {}
}

open class LiteralAddressType: AddressType {
    public static var providesWriteAccess: Bool { false }
    
    public static var readAccess: ReadAccess { .instantLiteralRead }
    
    open class var addressCode: UInt8 { 2 }
    
    public required init() {}
}

open class IndirectAddressAddressType: AddressType {
    public static var providesWriteAccess: Bool { true }
    
    public static var readAccess: ReadAccess { .read }
    
    open class var addressCode: UInt8 { 3 }
    
    public required init() {}
}

open class StackAddressType: AddressType {
    public static var providesWriteAccess: Bool { true }
    
    public static var readAccess: ReadAccess { .read }
    
    open class var addressCode: UInt8 { 4 }
    
    public required init() {}
}

open class IndirectStackAddressType: AddressType {
    public static var providesWriteAccess: Bool { true }
    
    public static var readAccess: ReadAccess { .read }
    
    open class var addressCode: UInt8 { 5 }
    
    public required init() {}
}

open class LiteralStackAddressType: AddressType {
    public static var providesWriteAccess: Bool { false }
    
    public static var readAccess: ReadAccess { .read }
    
    open class var addressCode: UInt8 { 6 }
    
    public required init() {}
}

open class NoAddressType: AddressType {
    public static var providesWriteAccess: Bool { false }
    
    public static var readAccess: ReadAccess { .none }
    
    open class var addressCode: UInt8 { 0 }
    
    public required init() {}
}

extension CPUStandardVars {
    public static var standardAddressTypes: [AddressTypeInit] { [
        AddressAddressType.init,
        LiteralAddressType.init,
        IndirectAddressAddressType.init,
        StackAddressType.init,
        IndirectStackAddressType.init,
        LiteralStackAddressType.init,
        NoAddressType.init,
    ]}
}
