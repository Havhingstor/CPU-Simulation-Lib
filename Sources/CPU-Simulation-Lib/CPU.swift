//
//  CPU.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation

public class CPU {
    private var _memory: Memory
    private var execution: CPUExecution
    private var internalVars: InternalCPUVars
    
    public init(memory: Memory, startingPoint: UInt16 = 0) {
        _memory = memory
        execution = CPUExecution()
        internalVars = InternalCPUVars()
        execution.programCounter = startingPoint
    }
    
    public var memory: Memory { _memory }
    public var programCounter: UInt16 { execution.programCounter }
    public var state: String { execution.state.state }
    public var opcode: UInt16 { execution.opcode }
    public var referencedAddress: UInt16 { execution.referencedAddress }
    public var stackpointer: UInt16 { internalVars.stackpointer }
    public var accumulator: UInt16 { internalVars.accumulator }
    public var dataBus: UInt16 { internalVars.dataBus }
    public var addressBus: UInt16 { internalVars.addressBus }
    public var lastMemoryInteraction: UInt16 { internalVars.lastMemoryInteraction }
    
    public func executeNextStep() {
        let result = execution.executeNextStep(parent: self)
        
        execution.applyNewCPUVars(vars: result)
        internalVars.applyNewCPUVars(vars: result)
    }
    
    public func endInstruction() {
        repeat {
            executeNextStep()
        } while !execution.state.instructionEnded
    }
    
    public func reset(startingPoint: UInt16 = 0) {
        execution = CPUExecution()
        internalVars = InternalCPUVars()
        execution.programCounter = startingPoint
    }
}



public class NewCPUVars {
    private var _programCounter: UInt16? = nil
    private var _opcode: UInt16? = nil
    private var _referencedAddress: UInt16? = nil
    private var _stackpointer: UInt16? = nil
    private var _accumulator: UInt16? = nil
    private var _dataBus: UInt16? = nil
    private var _addressBus: UInt16? = nil
    private var _lastMemoryInteraction: UInt16? = nil
    
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
    public var referencedAddress: UInt16? {
        get {_referencedAddress}
        set(referencedAddress) { if referencedAddress != nil
            { _referencedAddress = referencedAddress}
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
}
