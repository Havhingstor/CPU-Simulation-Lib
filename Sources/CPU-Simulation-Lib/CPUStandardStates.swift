//
//  CPUStandardStates.swift
//  
//
//  Created by Paul on 11.02.22.
//

import Foundation

open class ExecutedToFetchOperatorState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(FetchedOperatorToDecodeState.init))
    
    public let nextStateProvider: SingleNextStateProvider = ExecutedToFetchOperatorState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    open class var state: String { "executed" }
    public static var instructionEnded: Bool { true }
    
    open func operate(cpu: CPU) -> NewCPUVars {
        let result = fetchOperator(cpu: cpu)
        
        result.programCounter = cpu.programCounter &+ 1
        
        return result
    }
    
    public init() {}
}

open class HoldToFetchOperatorState: ExecutedToFetchOperatorState {
    open class override var state: String { "hold" }
}

open class FetchedOperatorToDecodeState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(DecodedToFetchOperandState.init))
    
    public let nextStateProvider: SingleNextStateProvider = FetchedOperatorToDecodeState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    open class var state: String { "operator-fetched" }
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPU) throws -> NewCPUVars {
        try decodeInstruction(cpu: cpu)
    }
    
    public init() {}
}

open class DecodedToFetchOperandState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(FetchedOperandToExecuteState.init))
    
    public let nextStateProvider: SingleNextStateProvider = DecodedToFetchOperandState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    open class var state: String { "decoded" }
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPU) -> NewCPUVars {
        let result = fetchOperand(cpu: cpu)
        
        result.programCounter = cpu.programCounter &+ 1
        
        return result
    }
    
    public init() {}
}

open class FetchedOperandToExecuteState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(ExecutedToFetchOperatorState.init))
    
    public let nextStateProvider: SingleNextStateProvider = FetchedOperandToExecuteState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    open class var state: String {"operand-fetched"}
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPU) -> NewCPUVars {
        return executeInstruction(cpu: cpu)
    }
    
    public init() {}
}
