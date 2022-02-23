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
    
    public var realOperandType: AccessibleOperandType? { executor.realOperandType }
    
    public var operatorProgramCounter: UInt16 { executor.operatorProgramCounter }
    
    public func executeNextStep() throws {
        let result = try executor.executeNextStep(parent: self)
        
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


public class NewCPUVars {
    private var _programCounter: UInt16? = nil
    private var _opcode: UInt16? = nil
    private var _operand: UInt16? = nil
    private var _stackpointer: UInt16? = nil
    private var _accumulator: UInt16? = nil
    private var _dataBus: UInt16? = nil
    private var _addressBus: UInt16? = nil
    private var _lastMemoryInteraction: UInt16? = nil
    private var _operator: Operator? = nil
    private var _operandType: AccessibleOperandType? = nil
    private var _vFlag: Bool? = nil
    
    public init() {}
    
    public var programCounter: UInt16? {
        get {_programCounter}
        set(programCounter) { if programCounter != nil
            { _programCounter = programCounter}
        }
    }
    public var opcode: UInt16? {
        get {_opcode}
        set(opcode) { if opcode != nil
            {_opcode = opcode}
        }
    }
    public var operand: UInt16? {
        get {_operand}
        set(operand) { if operand != nil
            { _operand = operand}
        }
    }
    public var stackpointer: UInt16? {
        get {_stackpointer}
        set(stackpointer) { if stackpointer != nil
            { _stackpointer = stackpointer}
        }
    }
    public var accumulator: UInt16? {
        get {_accumulator}
        set(accumulator) { if accumulator != nil
            { _accumulator = accumulator}
        }
    }
    public var dataBus: UInt16? {
        get {_dataBus}
        set(dataBus) { if dataBus != nil
            { _dataBus = dataBus}
        }
    }
    public var addressBus: UInt16? {
        get {_addressBus}
        set(addressBus) { if addressBus != nil
            { _addressBus = addressBus}
        }
    }
    public var lastMemoryInteraction: UInt16? {
        get {_lastMemoryInteraction}
        set(lastMemoryInteraction) { if lastMemoryInteraction != nil
            { _lastMemoryInteraction = lastMemoryInteraction}
        }
    }
    public var currentOperator: Operator? {
        get {_operator}
        set(currentOperator) { if currentOperator != nil
            { _operator = currentOperator }
        }
    }
    public var operandType: AccessibleOperandType? {
        get {_operandType}
        set(operandType) { if operandType != nil
            { _operandType = operandType }
        }
    }
    public var vFlag: Bool? {
        get { _vFlag }
        set (vFlag) { if vFlag != nil
            { _vFlag = vFlag }
        }
    }
}
