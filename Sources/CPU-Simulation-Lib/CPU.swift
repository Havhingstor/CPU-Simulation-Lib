//
//  CPU.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation

public class CPU {
    private let _memory: Memory
    private var executor: CPUExecutor
    private var internalVars: InternalCPUVars
    
    public init(memory: Memory, startingPoint: UInt16 = 0) {
        _memory = memory
        executor = CPUExecutor()
        internalVars = InternalCPUVars()
        executor.programCounter = startingPoint
    }
    
    public var memory: Memory { _memory }
    
    public var programCounter: UInt16 { executor.programCounter }
    public var state: String { executor.state.state }
    public var opcode: UInt16 { executor.opcode }
    public var operand: UInt16 { executor.operand }
    public var stackpointer: UInt16 { internalVars.stackpointer }
    
    public var accumulator: UInt16 { internalVars.accumulator }
    public var dataBus: UInt16? { internalVars.dataBus }
    public var addressBus: UInt16? { internalVars.addressBus }
    public var lastMemoryInteraction: UInt16 { internalVars.lastMemoryInteraction }
    public var nFlag: Bool { internalVars.nFlag }
    public var zFlag: Bool { internalVars.zFlag }
    public var vFlag: Bool { internalVars.vFlag }
    
    public var operatorString: String { currentOperator?.stringRepresentation ?? StandardCPUVars.startingOperatorString }
    public var currentOperator: Operator? { executor.currentOperator }
    
    public var operandTypeCode: UInt8 { operandType?.operandTypeCode ?? 0 }
    public var operandType: CoreOperandType? { executor.operandType }
    
    public var operatorProgramCounter: UInt16 { executor.operatorProgramCounter }
    
    public func executeNextStep() throws {
        let result = try executor.executeNextStep(parent: createCopy())
        
        executor.applyNewCPUVars(vars: result)
        internalVars.applyNewCPUVars(vars: result)
    }
    
    public func endInstruction() throws {
        repeat {
            try executeNextStep()
        } while !executor.state.instructionEnded
    }
    
    public func reset(startingPoint: UInt16 = 0) {
        executor = CPUExecutor()
        internalVars = InternalCPUVars()
        executor.programCounter = startingPoint
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
                realOperandType: executor.realOperandType,
                operatorProgramCounter: operatorProgramCounter)
    }
}
