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
}
