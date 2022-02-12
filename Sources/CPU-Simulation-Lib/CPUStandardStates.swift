//
//  CPUStandardStates.swift
//  
//
//  Created by Paul on 11.02.22.
//

import Foundation

public class ExecutedState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(FetchedState.init))
    
    public var nextStateProvider: SingleNextStateProvider = ExecutedState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    public var state: String { "executed" }
    public var instructionEnded: Bool { true }
    
    public func operate(cpu: CPU) -> NewCPUVars {
        let result = fetchInstruction(cpu: cpu)
        
        result.programCounter = cpu.programCounter &+ 2
        
        return result
    }
    
    public init() {}
}

public class HoldState: ExecutedState {
    public override var state: String { "hold" }
}

public class FetchedState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(DecodedState.init))
    
    public var nextStateProvider: SingleNextStateProvider = FetchedState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    public var state: String { "fetched" }
    public var instructionEnded: Bool { false }
    
    public func operate(cpu: CPU) -> NewCPUVars {
        var result = NewCPUVars()
        
        resetBusses(dest: &result)
        
        return result
    }
    
    public init() {}
}

public class DecodedState: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(ExecutedState.init))
    
    public var nextStateProvider: SingleNextStateProvider = DecodedState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    public var state: String {"decoded"}
    public var instructionEnded: Bool { false }
    
    public func operate(cpu: CPU) -> NewCPUVars {
        return NewCPUVars()
    }
    
    public init() {}
}
