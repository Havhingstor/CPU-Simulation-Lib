//
//  CPUState.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation
extension CPU {
    public static var startingState: StateBuilder = StateHold.Builder()
    public static var standardStartingState: StateBuilder { StateHold.Builder() }
}

public protocol CPUState {
    var state: String { get }
    var nextState: StateBuilder { get }
    var instructionEnded: Bool { get }
    
    func operate(cpu: CPU) -> NewCPUVars
    
}

public protocol StateBuilder {
    func generate() -> CPUState
}

public class StateExecuted: CPUState {
    public var state: String { "executed" }
    public var instructionEnded: Bool { true }
    
    public var nextState: StateBuilder {StateFetched.Builder()}
    
    public func operate(cpu: CPU) -> NewCPUVars {
        let result = fetchInstruction(cpu: cpu)
        
        result.programCounter = cpu.programCounter &+ 2
        
        return result
    }
    
    public init() {}
    
    class Builder: StateBuilder {
        func generate() -> CPUState {
            StateExecuted()
        }
    }
}

public class StateHold: StateExecuted {
    public override var state: String { "hold" }
    
    class Builder: StateBuilder {
        func generate() -> CPUState {
            StateHold()
        }
    }
}

public class StateFetched: CPUState {
    public var state: String { "fetched" }
    public var instructionEnded: Bool { false }
    
    public var nextState: StateBuilder {StateDecoded.Builder()}
    
    public func operate(cpu: CPU) -> NewCPUVars {
        return NewCPUVars()
    }
    
    public init() {}
    
    class Builder: StateBuilder {
        func generate() -> CPUState {
            StateFetched()
        }
    }
}

public class StateDecoded: CPUState {
    public var state: String {"decoded"}
    public var instructionEnded: Bool { false }
    
    public var nextState: StateBuilder {StateExecuted.Builder()}
    
    public func operate(cpu: CPU) -> NewCPUVars {
        return NewCPUVars()
    }
    
    public init() {}
    
    class Builder: StateBuilder {
        func generate() -> CPUState {
            StateDecoded()
        }
    }
}
