//
//  StateStandards.swift
//  
//
//  Created by Paul on 11.02.22.
//

import Foundation
import CPU_Simulation_Utilities

public class StandardStates {
    public typealias Builder = CPUState.Builder
    
    public static var startingState: Builder = originalStartingState
    public static var originalStartingState: Builder { HoldState.init }
    public static func resetStartingState() {
        startingState = originalStartingState
    }
}

open class HoldState: ExecutedState {
    override open class var state: String { "hold" }
    
    override open func operate(cpu: CPUCopy) -> NewCPUVars {
        NewCPUVars()
    }
}

open class OperatorFetchedState: CPUState {
    public let id: UUID = UUID()
    
    public static let standardNextStateProvider: StandardNextValueProvider<CPUState> = StandardNextValueProvider(builder: DecodedState.init)
    
    
    open class var state: String { "operator-fetched" }
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPUCopy) -> NewCPUVars {
        let result = fetchOpcode(cpu: cpu)
        
        increaseProgramCounter(result: result,cpu: cpu)
        
        return result
    }
    
    public init() {}
}

open class DecodedState: CPUState {
    public let id: UUID = UUID()
    
    public static let standardNextStateProvider: StandardNextValueProvider<CPUState> = StandardNextValueProvider(builder: OperandFetchedState.init)
    
    open class var state: String { "decoded" }
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPUCopy) throws -> NewCPUVars {
        try decodeInstruction(cpu: cpu)
    }
    
    public init() {}
}

open class OperandFetchedState: CPUState {
    public let id: UUID = UUID()
    
    public static let standardNextStateProvider: StandardNextValueProvider<CPUState> = StandardNextValueProvider(builder: ExecutedState.init)
    
    open class var state: String { "operand-fetched" }
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPUCopy) -> NewCPUVars {
        let result = fetchOperand(cpu: cpu)
        
        increaseProgramCounter(result: result, cpu: cpu)
        
        return result
    }
    
    public init() {}
}

open class ExecutedState: CPUState {
    public let id: UUID = UUID()
    
    public static let standardNextStateProvider: StandardNextValueProvider<CPUState> = StandardNextValueProvider(builder: OperatorFetchedState.init)
    
    open class var state: String {"executed"}
    public static var instructionEnded: Bool { true }
    
    open func operate(cpu: CPUCopy) -> NewCPUVars {
        return executeInstruction(cpu: cpu)
    }
    
    public init() {}
}

fileprivate func increaseProgramCounter(result: NewCPUVars, cpu: CPUCopy) {
    result.programCounter = cpu.programCounter &+ 1
}
