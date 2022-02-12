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
    
    init()
}

extension Operator {
    public var stringRepresentation: String { Self.stringRepresentation }
    public var operatorCode: UInt8 { Self.operatorCode }
}
