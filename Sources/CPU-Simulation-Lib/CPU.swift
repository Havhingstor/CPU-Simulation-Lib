//
//  CPU.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation

public class CPU {
    private var _memory: Memory
    private var _programCounter: UInt16 = 0
    private var _state: CPUState = CPU.startingState
    private var _opcode: UInt16 = 0
    private var _referencedAddress: UInt16 = 0
    
    public init(memory: Memory) {
        _memory = memory
    }
    
    public init(memory: Memory, startingPoint: UInt16) {
        _memory = memory
        _programCounter = startingPoint
    }
    
    public var memory: Memory { _memory }
    public var programCounter: UInt16 { _programCounter }
    public var state: String { _state.state }
    public var opcode: UInt16 { _opcode }
    public var referencedAddress: UInt16 { _referencedAddress }
    
    
    public func executeNextStep() {
        applyNewCPUVars(vars: _state.operate(cpu: self))
        _state = _state.nextState
    }
    
    public func endInstruction() {
        repeat {
            executeNextStep()
        } while !_state.instructionEnded
    }
    
    private func applyNewCPUVars(vars: NewCPUVars) {
        applyProgramCounter(pc: vars.programCounter)
        applyOpcode(opcode: vars.opcode)
        applyReferencedAddress(referencedAddress: vars.referencedAddress)
    }
    
    private func applyProgramCounter(pc: UInt16?) {
        if let pc = pc {
            _programCounter = pc
        }
    }
    
    private func applyOpcode(opcode: UInt16?) {
        if let opcode = opcode {
            _opcode = opcode
        }
    }
    
    private func applyReferencedAddress(referencedAddress: UInt16?) {
        if let referencedAddress = referencedAddress {
            _referencedAddress = referencedAddress
        }
    }
}

public class NewCPUVars {
    private var _programCounter: UInt16? = nil
    private var _opcode: UInt16? = nil
    private var _referencedAddress: UInt16? = nil
    
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
}
