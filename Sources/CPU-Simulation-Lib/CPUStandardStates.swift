//
//  CPUStandardStates.swift
//  
//
//  Created by Paul on 11.02.22.
//

import Foundation

public class ExecutedToFetchState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(FetchedToDecodeState.init))
    
    public var nextStateProvider: SingleNextStateProvider = ExecutedToFetchState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    public var state: String { "executed" }
    public var instructionEnded: Bool { true }
    
    public func operate(cpu: CPU) -> NewCPUVars {
        let result = fetchInstruction(cpu: cpu)
        
        result.programCounter = cpu.programCounter &+ 2
        
        return result
    }
    
    public init() {}
}

public class HoldToFetchState: ExecutedToFetchState {
    public override var state: String { "hold" }
}

public class FetchedToDecodeState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(DecodedToExecuteState.init))
    
    public var nextStateProvider: SingleNextStateProvider = FetchedToDecodeState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    public var state: String { "fetched" }
    public var instructionEnded: Bool { false }
    
    public func operate(cpu: CPU) -> NewCPUVars {
        var result = NewCPUVars()
        
        resetBusses(dest: &result)
        
        return result
    }
    
    public init() {}
}

public class DecodedToExecuteState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(ExecutedToFetchState.init))
    
    public var nextStateProvider: SingleNextStateProvider = DecodedToExecuteState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    public var state: String {"decoded"}
    public var instructionEnded: Bool { false }
    
    public func operate(cpu: CPU) -> NewCPUVars {
        return NewCPUVars()
    }
    
    public init() {}
}
