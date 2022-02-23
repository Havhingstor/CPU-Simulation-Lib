//
//  CPUStandardStates.swift
//  
//
//  Created by Paul on 11.02.22.
//

import Foundation

public class StandardStates {
    public static var startingState: StateBuilder = originalStartingState
    public static var originalStartingState: StateBuilder { StateBuilder(HoldToFetchOperatorState.init) }
    public static func resetStartingState() {
        startingState = originalStartingState
    }
}

open class ExecutedToFetchOperatorState: CPUState {
    public static let standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(FetchedOperatorToDecodeState.init))
    
    public let nextStateProvider: SingleNextStateProvider = ExecutedToFetchOperatorState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    open class var state: String { "executed" }
    public static var instructionEnded: Bool { true }
    
    open func operate(cpu: CPU) -> NewCPUVars {
        let result = fetchOperator(cpu: cpu)
        
        increaseProgramCounter(result: result,cpu: cpu)
        
        return result
    }
    
    public init() {}
}

open class HoldToFetchOperatorState: ExecutedToFetchOperatorState {
    open class override var state: String { "hold" }
}

open class FetchedOperatorToDecodeState: CPUState {
    public static let standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(DecodedToFetchOperandState.init))
    
    public let nextStateProvider: SingleNextStateProvider = FetchedOperatorToDecodeState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    open class var state: String { "operator-fetched" }
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPU) throws -> NewCPUVars {
        try decodeInstruction(cpu: cpu)
    }
    
    public init() {}
}

open class DecodedToFetchOperandState: CPUState {
    public static let standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(FetchedOperandToExecuteState.init))
    
    public let nextStateProvider: SingleNextStateProvider = DecodedToFetchOperandState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    open class var state: String { "decoded" }
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPU) -> NewCPUVars {
        let result = fetchOperand(cpu: cpu)
        
        increaseProgramCounter(result: result, cpu: cpu)
        
        return result
    }
    
    public init() {}
}

open class FetchedOperandToExecuteState: CPUState {
    public static let standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(ExecutedToFetchOperatorState.init))
    
    public let nextStateProvider: SingleNextStateProvider = FetchedOperandToExecuteState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    open class var state: String {"operand-fetched"}
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPU) -> NewCPUVars {
        return executeInstruction(cpu: cpu)
    }
    
    public init() {}
}

fileprivate func increaseProgramCounter(result: NewCPUVars, cpu: CPU) {
    result.programCounter = cpu.programCounter &+ 1
}
