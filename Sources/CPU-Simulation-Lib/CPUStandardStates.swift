//
//  CPUStandardStates.swift
//  
//
//  Created by Paul on 11.02.22.
//

import Foundation

open class ExecutedToFetchState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(FetchedToDecodeState.init))
    
    public var nextStateProvider: SingleNextStateProvider = ExecutedToFetchState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    open class var state: String { "executed" }
    open class var instructionEnded: Bool { true }
    
    open func operate(cpu: CPU) -> NewCPUVars {
        let result = fetchInstruction(cpu: cpu)
        
        result.programCounter = cpu.programCounter &+ 2
        
        return result
    }
    
    public init() {}
}

open class HoldToFetchState: ExecutedToFetchState {
    open class override var state: String { "hold" }
}

open class FetchedToDecodeState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(DecodedToExecuteState.init))
    
    public var nextStateProvider: SingleNextStateProvider = FetchedToDecodeState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    open class var state: String { "fetched" }
    open class var instructionEnded: Bool { false }
    
    open func operate(cpu: CPU) throws -> NewCPUVars {
        try decodeInstruction(cpu: cpu)
    }
    
    public init() {}
}

open class DecodedToExecuteState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(ExecutedToFetchState.init))
    
    public var nextStateProvider: SingleNextStateProvider = DecodedToExecuteState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    open class var state: String {"decoded"}
    open class var instructionEnded: Bool { false }
    
    open func operate(cpu: CPU) -> NewCPUVars {
        return NewCPUVars()
    }
    
    public init() {}
}
