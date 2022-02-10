//
//  CPUState.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation
extension CPU {
    public static var startingState: CPUState = StateHold()
    public static var standardStartingState: CPUState { StateHold() }
}

public protocol CPUState {
    var state: String { get }
    var nextState: CPUState { get }
    var instructionEnded: Bool { get }
    
    func operate(cpu: CPU) -> NewCPUVars
    
}

public class StateExecuted: CPUState {
    public var state: String { "executed" }
    public var instructionEnded: Bool { true }
    
    public var nextState: CPUState {StateFetched()}
    
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
    public var state: String { "fetched" }
    public var instructionEnded: Bool { false }
    
    public var nextState: CPUState {StateDecoded()}
    
    public func operate(cpu: CPU) -> NewCPUVars {
        return NewCPUVars()
    }
    
    public init() {}
}

public class StateDecoded: CPUState {
    public var state: String {"decoded"}
    public var instructionEnded: Bool { false }
    
    public var nextState: CPUState {StateExecuted()}
    
    public func operate(cpu: CPU) -> NewCPUVars {
        return NewCPUVars()
    }
    
    public init() {}
}
