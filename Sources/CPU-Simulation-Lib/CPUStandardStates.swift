//
//  CPUStandardStates.swift
//  
//
//  Created by Paul on 11.02.22.
//

import Foundation

public class StateExecuted: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(StateFetched.init))
    
    public var nextStateProvider: SingleNextStateProvider = StateExecuted.standardNextStateProvider.getNewSingleNextStateProvider()
    
    public var state: String { "executed" }
    public var instructionEnded: Bool { true }
    
    public func operate(cpu: CPU) -> NewCPUVars {
        let result = fetchInstruction(cpu: cpu)
        
        result.programCounter = cpu.programCounter &+ 2
        
        return result
    }
    
    public init() {}
}

public class StateHold: StateExecuted {
    public override var state: String { "hold" }
}

public class StateFetched: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(StateDecoded.init))
    
    public var nextStateProvider: SingleNextStateProvider = StateFetched.standardNextStateProvider.getNewSingleNextStateProvider()
    
    public var state: String { "fetched" }
    public var instructionEnded: Bool { false }
    
    public func operate(cpu: CPU) -> NewCPUVars {
        return NewCPUVars()
    }
    
    public init() {}
}

public class StateDecoded: CPUState {
    public static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(StateExecuted.init))
    
    public var nextStateProvider: SingleNextStateProvider = StateDecoded.standardNextStateProvider.getNewSingleNextStateProvider()
    
    public var state: String {"decoded"}
    public var instructionEnded: Bool { false }
    
    public func operate(cpu: CPU) -> NewCPUVars {
        return NewCPUVars()
    }
    
    public init() {}
}
