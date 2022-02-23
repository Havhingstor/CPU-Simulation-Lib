//
//  CPUState.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation

public protocol CPUState {
    static var state: String { get }
    static var standardNextStateProvider: StandardNextStateProvider { get }
    var nextStateProvider: SingleNextStateProvider { get }
    static var instructionEnded: Bool { get }
    
    func operate(cpu: CPU) throws -> NewCPUVars
}

extension CPUState {
    public var nextState: StateBuilder { nextStateProvider.nextState }
    
    public static var standardNextState: StateBuilder {
        get {
            Self.standardNextStateProvider.standardNextState
        }
        set(newStandardNextState) {
            Self.standardNextStateProvider.standardNextState = newStandardNextState
        }
    }
    
    public static func resetStandardNextState() {
        standardNextStateProvider.resetStandardNextState()
    }
    
    public var state: String { Self.state }
    public var instructionEnded: Bool { Self.instructionEnded }
}

public class StandardNextStateProvider {
    
    private let _originalStandardNextState: StateBuilder
    private var _standardNextState: StateBuilder?
    
    public init(original: StateBuilder) {
        _originalStandardNextState = original
    }
    
    public func resetStandardNextState() {
        _standardNextState = nil
    }
    
    public var originalStandardNextState: StateBuilder {_originalStandardNextState}
    public var standardNextState: StateBuilder {
        get {
            if let standardNextState = _standardNextState {
                return standardNextState
            }
            return originalStandardNextState
        }
        set(newStandardNextState) {
            _standardNextState = newStandardNextState
        }
    }
    
    public func getNewSingleNextStateProvider() -> SingleNextStateProvider {
        SingleNextStateProvider(self)
    }
}

public class SingleNextStateProvider {
    
    private var _nextState: StateBuilder?
    private let parent: StandardNextStateProvider
    
    fileprivate init(_ parent: StandardNextStateProvider) {
        self.parent = parent
    }
    
    public var nextState: StateBuilder {
        get {
            if let nextState = _nextState {
                return nextState
            }
            return parent.standardNextState
        }
        set(newNextState) {
            _nextState = newNextState
        }
    }
    
    public func resetNextState() {
        _nextState = nil
    }
}

public class StateBuilder: Equatable {
    public static func == (lhs: StateBuilder, rhs: StateBuilder) -> Bool {
        lhs.function().state == rhs.function().state
    }
    
    private let function: () -> CPUState
    
    public init(_ function: @escaping () -> CPUState) {
        self.function = function
    }
    
    public func generate() -> CPUState {
        function()
    }
}
