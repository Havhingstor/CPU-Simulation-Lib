//
//  CPUAddressType.swift
//  
//
//  Created by Paul on 14.02.22.
//

import Foundation

public protocol AddressType {
    static var addressCode: UInt8 { get }
    static var providesWriteAccess: Bool { get }
    static var readAccess: ReadAccess { get }
    
    init()
}

extension AddressType {
    public var addressCode: UInt8 { Self.addressCode }
    public var addressCodePreparedForOpcode: UInt16 { UInt16(addressCode) << 8}
    public var isNothing: Bool { !providesWriteAccess && Self.readAccess == .none}
    public var providesInstantLiteral: Bool { Self.readAccess == .instantLiteralRead }
    public var providesWriteAccess: Bool { Self.providesWriteAccess }
}

public enum ReadAccess {
    case none
    case read
    case instantLiteralRead
}
