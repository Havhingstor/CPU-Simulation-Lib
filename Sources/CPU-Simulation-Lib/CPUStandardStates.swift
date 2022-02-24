//
//  CPUStandardStates.swift
//  
//
//  Created by Paul on 11.02.22.
//

import Foundation
import CPU_Simulation_Utilities

public class StandardStates {
    public typealias Builder = CPUState.Builder
    
    public static var startingState: Builder = originalStartingState
    public static var originalStartingState: Builder { HoldToFetchOperatorState.init }
    public static func resetStartingState() {
        startingState = originalStartingState
    }
}

open class ExecutedToFetchOperatorState: CPUState {
    public let id: UUID = UUID()
    
    public static let standardNextStateProvider: StandardNextValueProvider<CPUState> = StandardNextValueProvider(builder: FetchedOperatorToDecodeState.init)
    
    
    open class var state: String { "executed" }
    public static var instructionEnded: Bool { true }
    
    open func operate(cpu: CPU) -> NewCPUVars {
        let result = fetchOperator(cpu: cpu)
        
        increaseProgramCounter(result: result,cpu: cpu)
        
        return result
    }
    
    public init() {}
}

open class HoldToFetchOperatorState: ExecutedToFetchOperatorState {
    open class override var state: String { "hold" }
}

open class FetchedOperatorToDecodeState: CPUState {
    public let id: UUID = UUID()
    
    public static let standardNextStateProvider: StandardNextValueProvider<CPUState> = StandardNextValueProvider(builder: DecodedToFetchOperandState.init)
    
    open class var state: String { "operator-fetched" }
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPU) throws -> NewCPUVars {
        try decodeInstruction(cpu: cpu)
    }
    
    public init() {}
}

open class DecodedToFetchOperandState: CPUState {
    public let id: UUID = UUID()
    
    public static let standardNextStateProvider: StandardNextValueProvider<CPUState> = StandardNextValueProvider(builder: FetchedOperandToExecuteState.init)
    
    open class var state: String { "decoded" }
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPU) -> NewCPUVars {
        let result = fetchOperand(cpu: cpu)
        
        increaseProgramCounter(result: result, cpu: cpu)
        
        return result
    }
    
    public init() {}
}

open class FetchedOperandToExecuteState: CPUState {
    public let id: UUID = UUID()
    
    public static let standardNextStateProvider: StandardNextValueProvider<CPUState> = StandardNextValueProvider(builder: ExecutedToFetchOperatorState.init)
    
    open class var state: String {"operand-fetched"}
    public static var instructionEnded: Bool { false }
    
    open func operate(cpu: CPU) -> NewCPUVars {
        return executeInstruction(cpu: cpu)
    }
    
    public init() {}
}

fileprivate func increaseProgramCounter(result: NewCPUVars, cpu: CPU) {
    result.programCounter = cpu.programCounter &+ 1
}
