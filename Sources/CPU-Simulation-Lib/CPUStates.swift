//
//  CPUStates.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation
import CPU_Simulation_Utilities

public protocol CPUState {
    typealias Builder = StandardNextValueProvider<CPUState>.Builder

    static var state: String { get }
    static var standardNextStateProvider: StandardNextValueProvider<CPUState> { get }
    var id: UUID { get }
    static var instructionEnded: Bool { get }
    
    func operate(cpu: CPU) throws -> NewCPUVars
}

extension CPUState {
    public var nextState: Builder { Self.standardNextStateProvider.getNextValue(uuid: id) }
    
    public static var standardNextState: Builder {
        get {
            standardNextStateProvider.standardNextValue
        }
        set(newStandardNextState) {
            standardNextStateProvider.standardNextValue = newStandardNextState
        }
    }
    
    public static func resetStandardNextState() {
        standardNextStateProvider.resetStandardNextValue()
    }
    
    public var state: String { Self.state }
    public var instructionEnded: Bool { Self.instructionEnded }
}
