//
//  CPUStandardVars.swift
//  
//
//  Created by Paul on 11.02.22.
//

import Foundation

public class CPUStandardVars {
    public static var startingState: StateBuilder = originalStartingState
    public static var originalStartingState: StateBuilder { StateBuilder(HoldToFetchOperatorState.init) }
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
    
    public typealias operandTypeInit = () -> OperandType
    public static var operandTypes: [operandTypeInit] = standardOperandTypes
    public static func resetOperandTypes() {
        operandTypes = standardOperandTypes
    }
    
    public static func getOperandTypeAssignment() -> [UInt8 : operandTypeInit] {
        var result: [UInt8 : operandTypeInit] = [:]
        
        for operandTypeGenerator in operandTypes {
            addOperandTypeToAssignment(operandTypeGenerator: operandTypeGenerator, dict: &result)
        }
        
        return result
    }
    
    private static func addOperandTypeToAssignment(operandTypeGenerator: @escaping operandTypeInit, dict: inout [UInt8 : operandTypeInit]) {
        let operandType = operandTypeGenerator()
        dict.updateValue(operandTypeGenerator, forKey: operandType.operandTypeCode)
    }
    
    public static var startingOperatorString: String = originalStartingOperatorString
    public static var originalStartingOperatorString: String { "NOOP" }
    public static func resetStartingOperatorString() {
        startingOperatorString = originalStartingOperatorString
    }
}
