//
//  CPUErrors.swift
//  
//
//  Created by Paul on 12.02.22.
//

import Foundation

public enum CPUErrors: Error, Equatable {
    case OperatorCodeNotDecodable(address: UInt16, operatorCode: UInt8)
}
