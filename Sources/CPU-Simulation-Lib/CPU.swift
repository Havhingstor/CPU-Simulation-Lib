//
//  CPU.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation

public class CPU {
    private let _memory: Memory
    private var operationVars: CPUOperationVars
    private var internalVars: InternalCPUVars
    private var continuation = CPUContinuation.standard
    
    public init(memory: Memory, startingPoint: UInt16 = 0) {
        _memory = memory
        operationVars = CPUOperationVars()
        internalVars = InternalCPUVars()
        operationVars.programCounter = startingPoint
    }
    
    public var memory: Memory { _memory }
    
    public var programCounter: UInt16 { operationVars.programCounter }
    public var state: String { operationVars.state.state }
    public var opcode: UInt16 { operationVars.opcode }
    public var operand: UInt16 { operationVars.operand }
    public var stackpointer: UInt16 { internalVars.stackpointer }
    
    public var accumulator: UInt16 { internalVars.accumulator }
    public var dataBus: UInt16? { internalVars.dataBus }
    public var addressBus: UInt16? { internalVars.addressBus }
    public var lastMemoryInteraction: UInt16 { internalVars.lastMemoryInteraction }
    public var nFlag: Bool { internalVars.nFlag }
    public var zFlag: Bool { internalVars.zFlag }
    public var vFlag: Bool { internalVars.vFlag }
    
    public var operatorString: String { currentOperator?.stringRepresentation ?? StandardCPUVars.startingOperatorString }
    public var currentOperator: Operator? { operationVars.currentOperator }
    
    public var operandTypeCode: UInt8 { operandType?.operandTypeCode ?? 0 }
    public var operandType: CoreOperandType? { operationVars.operandType }
    
    public var operatorProgramCounter: UInt16 { operationVars.operatorProgramCounter }
    
    public func operateNextStep() throws {
        let result = try operationVars.operateNextStep(parent: createCopy())
        
        operationVars.applyNewCPUVars(vars: result)
        internalVars.applyNewCPUVars(vars: result)
        
        continuation = result.continuation
        
        if continuation == .reset {
            reset()
        }
    }
    
    public func endInstruction() throws {
        repeat {
            try operateNextStep()
        } while !operationVars.state.instructionEnded
    }
    
    public func run() throws {
        while continuation == .standard {
            try endInstruction()
        }
        continuation = .standard
        operationVars.state = StandardStates.startingState()
    }
    
    public func reset(startingPoint: UInt16 = 0) {
        operationVars = CPUOperationVars()
        internalVars = InternalCPUVars()
        operationVars.programCounter = startingPoint
    }
}

public class StandardCPUVars {
    public static var startingOperatorString: String = originalStartingOperatorString
    public static var originalStartingOperatorString: String { "NOOP" }
    public static func resetStartingOperatorString() {
        startingOperatorString = originalStartingOperatorString
    }
}

extension CPU {
    public func createCopy() -> CPUCopy {
        CPUCopy(memory: memory,
                programCounter: programCounter,
                opcode: opcode,
                operand: operand,
                stackpointer: stackpointer,
                accumulator: accumulator,
                nFlag: nFlag, zFlag: zFlag, vFlag: vFlag,
                currentOperator: currentOperator,
                operandType: operandType,
                realOperandType: operationVars.realOperandType,
                operatorProgramCounter: operatorProgramCounter)
    }
}
