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
    
    func shouldIncrement() -> Bool
    
}

public class StateExecuted: CPUState {
    public var state: String { "executed" }
    
    public var nextState: CPUState {StateFetched()}
    
    public func shouldIncrement() -> Bool {
        true
    }
    
    public init() {}
}

public class StateHold: StateExecuted {
    public override var state: String { "hold" }
}

public class StateFetched: CPUState {
    public var state: String { "fetched" }
    
    public var nextState: CPUState {StateDecoded()}
    
    public func shouldIncrement() -> Bool {
        false
    }
    
    public init() {}
}

public class StateDecoded: CPUState {
    public var state: String {"decoded"}
    
    public var nextState: CPUState {StateExecuted()}
    
    public func shouldIncrement() -> Bool {
        false
    }
    
    public init() {}
}
