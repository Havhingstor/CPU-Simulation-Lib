//
//  CPU.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation

/// The interface for simulating a cpu and running programs on it
public class CPU {
    private let _memory: Memory
    private var operationVars: CPUOperationVars
    private var internalVars: InternalCPUVars
    private var continuation = CPUContinuation.standard
    private var _cycleCount: UInt = 0
    
    /// The maximal number of execution-cycles ``run()`` will perform, preventing a infinite loop
    public var maxCycles: UInt
    
    /// Initializes the cpu, creates the internal components
    /// - Parameters:
    ///   - memory: The memory from which the cpu will take its operations and with which these operations can interact
    ///   - startingPoint: The memory-address of the first operation, by default 0
    ///   - maxCycles: The maximal number of execution-cycles ``run()`` will perform, preventing a infinite loop, by default 100000
    public init(memory: Memory, startingPoint: UInt16 = 0, maxCycles: UInt = 100000) {
        _memory = memory
        operationVars = CPUOperationVars()
        internalVars = InternalCPUVars()
        operationVars.programCounter = startingPoint
        self.maxCycles = maxCycles
    }
    
    /// The memory from which the cpu will take its operations and with which these operations can interact
    public var memory: Memory { _memory }
    
    /// The current program counter, signaling the memory-address from which the next operator or operand will be read
    public var programCounter: UInt16 { operationVars.programCounter }
    /// The current state of the cpu, signaling which part of the execution-cycle was done last
    public var state: String { operationVars.state.state }
    /// The last fetched opcode
    public var opcode: UInt16 { operationVars.opcode }
    /// The last fetched operand
    public var operand: UInt16 { operationVars.operand }
    /// The stackpointer, pointing to the memory-address of the top of the stack
    public var stackpointer: UInt16 { internalVars.stackpointer }
    
    /// The accumulator, a cache inside the cpu
    public var accumulator: UInt16 { internalVars.accumulator }
    /// The data bus, which holds the value written to memory in this state, if any
    public var dataBus: UInt16? { internalVars.dataBus }
    /// The address bus, which holds the memory-address to which this state wrote data, if any
    public var addressBus: UInt16? { internalVars.addressBus }
    /// Stores if the last operation set the nFlag, usually to signal a negative operation-result
    public var nFlag: Bool { internalVars.nFlag }
    /// Stores if the last operation set the nFlag, usually to signal an operation-result beeing zero
    public var zFlag: Bool { internalVars.zFlag }
    /// Stores if the last operation set the nFlag, usually to signal an operation-result produced by an overflow
    public var vFlag: Bool { internalVars.vFlag }
    
    /// The string representation of the current ``operator``, or a default option in ``StandardCPUVars``
    public var operatorString: String { `operator`?.stringRepresentation ?? StandardCPUVars.startingOperatorString }
    /// The last decoded operator and `nil`, if no operator was decoded yet
    public var `operator`: Operator? { operationVars.`operator` }
    
    /// The code representation of the current ``operandType``, or a default option
    public var operandTypeCode: UInt8 { operandType?.operandTypeCode ?? 0 }
    /// The last fetched operandType and `nil`, if no operator was fetched yet
    public var operandType: CoreOperandType? { operationVars.operandType }
    
    /// The program counter of the next operator, differs from ``programCounter``, if that points to an operand
    public var operatorProgramCounter: UInt16 { operationVars.operatorProgramCounter }
    
    /// The number of execution-cycles used by the ``run()``-method
    public var cycleCount: UInt { _cycleCount }
    
    /// Operates the next step of the execution-cycle
    public func operateNextStep() throws {
        let result = try operationVars.operateNextStep(parent: createCopy())
        
        operationVars.applyNewCPUVars(vars: result)
        internalVars.applyNewCPUVars(vars: result)
        
        continuation = result.continuation
        
        if continuation == .reset {
            reset()
        }
    }
    
    /// Runs the program until the current operation is fully executed
    public func endInstruction() throws {
        repeat {
            try operateNextStep()
        } while !operationVars.state.instructionEnded
    }
    
    /// Runs the program until a holding-instruction is reached
    public func run() throws {
        _cycleCount = 0
        while continuation == .standard && cycleCount < maxCycles {
            try endInstruction()
            _cycleCount += 1
        }
        continuation = .standard
        operationVars.state = StandardStates.startingState()
    }
    
    /// Resets the cpu to its starting state
    /// - Parameters:
    ///   - startingPoint: The memory-address of the first operator, by default 0
    ///   - maxCycles: The maximal number of execution-cycles ``run()`` will perform, preventing a infinite loop, or `nil` if the old value shouldn't get overwritten
    public func reset(startingPoint: UInt16 = 0, maxCycles: UInt? = nil) {
        operationVars = CPUOperationVars()
        internalVars = InternalCPUVars()
        operationVars.programCounter = startingPoint
        applyMaxCycles(maxCycles: maxCycles)
    }

    private func applyMaxCycles(maxCycles: UInt?) {
        if let maxCycles = maxCycles {
            self.maxCycles = maxCycles 
        }
    }
}

/// A container for standard-vars, which can change the default-behavior of the cpu
public class StandardCPUVars {
    /// The operatorString which is used before a operator gets decoded, by default ``originalStartingOperatorString``
    public static var startingOperatorString: String = originalStartingOperatorString
    /// The original ``startingOperatorString`` (NOOP)
    public static var originalStartingOperatorString: String { "NOOP" }
    /// Resets the ``startingOperatorString`` to its original value (``originalStartingOperatorString``)
    public static func resetStartingOperatorString() {
        startingOperatorString = originalStartingOperatorString
    }
}

extension CPU {
    /// Copies the cpu without giving permission to change the values
    /// - Returns: A ``CPUCopy``, having the same values as the cpu
    public func createCopy() -> CPUCopy {
        CPUCopy(memory: memory,
                programCounter: programCounter,
                opcode: opcode,
                operand: operand,
                stackpointer: stackpointer,
                accumulator: accumulator,
                nFlag: nFlag, zFlag: zFlag, vFlag: vFlag,
                operator: `operator`,
                operandType: operandType,
                realOperandType: operationVars.realOperandType,
                operatorProgramCounter: operatorProgramCounter)
    }
}
