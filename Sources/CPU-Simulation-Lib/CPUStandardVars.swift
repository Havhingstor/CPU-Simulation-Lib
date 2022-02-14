//
//  CPUStandardVars.swift
//  
//
//  Created by Paul on 11.02.22.
//

import Foundation

public class CPUStandardVars {
    public static var startingState: StateBuilder = originalStartingState
    public static let originalStartingState: StateBuilder = StateBuilder(HoldToFetchState.init)
    public static func resetStartingState() {
        startingState = originalStartingState
    }
    
    public typealias OperatorInit = () -> Operator
    public static var operators: [OperatorInit] = standardOperators
    public static func resetOperators() {
        operators = standardOperators
    }
    
    public static func getOperatorAssignment() -> [UInt8 : OperatorInit] {
        var result: [UInt8 : OperatorInit] = [:]
        
        for operatorGenerator in operators {
            addOperatorToAssignment(operatorGenerator: operatorGenerator, dict: &result)
        }
        
        return result
    }
    
    private static func addOperatorToAssignment(operatorGenerator: @escaping OperatorInit, dict: inout [UInt8 : OperatorInit]) {
        let op = operatorGenerator()
        dict.updateValue(operatorGenerator, forKey: op.operatorCode)
    }
    
    public typealias AddressTypeInit = () -> AddressType
    public static var addressTypes: [AddressTypeInit] = standardAddressTypes
    public static func resetAddressTypes() {
        addressTypes = standardAddressTypes
    }
    
    public static func getAddressTypeAssignment() -> [UInt8 : AddressTypeInit] {
        var result: [UInt8 : AddressTypeInit] = [:]
        
        for addressTypeGenerator in addressTypes {
            addAddressTypeToAssignment(addressTypeGenerator: addressTypeGenerator, dict: &result)
        }
        
        return result
    }
    
    private static func addAddressTypeToAssignment(addressTypeGenerator: @escaping AddressTypeInit, dict: inout [UInt8 : AddressTypeInit]) {
        let addressType = addressTypeGenerator()
        dict.updateValue(addressTypeGenerator, forKey: addressType.addressCode)
    }
}
