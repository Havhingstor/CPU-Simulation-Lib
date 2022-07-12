//
//  CPURepresentation.swift
//  
//
//  Created by Paul on 25.02.22.
//

import Foundation

public struct CPUCopy {
    public var memory: Memory
    
    public var programCounter: UInt16
    public var opcode: UInt16
    public var operand: UInt16
    public var stackpointer: UInt16
    
    public var accumulator: UInt16
    public var nFlag: Bool
    public var zFlag: Bool
    public var vFlag: Bool
    
    public var `operator`: Operator?
    
    public var operandType: CoreOperandType?
    
    public var realOperandType: AccessibleOperandType?
    
    public var operatorProgramCounter: UInt16 
}

public class NewCPUVars {
    private var _programCounter: UInt16? = nil
    private var _opcode: UInt16? = nil
    private var _operand: UInt16? = nil
    private var _stackpointer: UInt16? = nil
    private var _accumulator: UInt16? = nil
    private var _dataBus: UInt16? = nil
    private var _addressBus: UInt16? = nil
    private var _operator: Operator? = nil
    private var _operandType: AccessibleOperandType? = nil
    private var _vFlag: Bool? = nil
    private var _zFlag: Bool? = nil
    private var _nFlag: Bool? = nil
    
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
    public var `operator`: Operator? {
        get {_operator}
        set(`operator`) { if `operator` != nil
            { _operator = `operator` }
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
    public var zFlag: Bool? {
        get { _zFlag }
        set (zFlag) { if zFlag != nil
            { _zFlag = zFlag }
        }
    }
    public var nFlag: Bool? {
        get { _nFlag }
        set (nFlag) { if nFlag != nil
            { _nFlag = nFlag }
        }
    }
    public var continuation: CPUContinuation = .standard
}

public enum CPUContinuation {
    case standard
    case hold
    case reset
}
