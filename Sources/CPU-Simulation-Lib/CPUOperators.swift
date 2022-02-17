//
//  CPUOperators.swift
//  
//
//  Created by Paul on 12.02.22.
//

import Foundation

public protocol Operator {
    static var stringRepresentation: String { get }
    static var operatorCode: UInt8 { get }
    static var requiresLiteralReadAccess: Bool { get }
    static var requiresAddressOrWriteAccess: Bool { get }
    static var dontAllowOperandIfPossible: Bool { get }
    
    init()
}

extension Operator {
    public var stringRepresentation: String { Self.stringRepresentation }
    public var operatorCode: UInt8 { Self.operatorCode }
    
    public var requiresLiteralReadAccess: Bool { Self.requiresLiteralReadAccess }
    public var requiresAddressOrWriteAccess: Bool { Self.requiresAddressOrWriteAccess }
    public var allowsNoOperand: Bool { Self.allowsNoOperand }
    
    public static var allowsNoOperand: Bool { !requiresLiteralReadAccess && !requiresAddressOrWriteAccess && dontAllowOperandIfPossible}
}
