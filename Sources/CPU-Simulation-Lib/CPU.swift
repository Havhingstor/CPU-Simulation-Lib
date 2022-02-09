//
//  CPU.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation

public class CPU {
    private var _memory: Memory
    private var _stackpointer: UInt16 = 0
    private var _state: CPUState = CPU.startingState
    
    public init(memory: Memory) {
        _memory = memory
    }
    
    public init(memory: Memory, startingPoint: UInt16) {
        _memory = memory
        _stackpointer = startingPoint
    }
    
    public var memory: Memory { _memory }
    public var stackpointer: UInt16 { _stackpointer }
    public var state: String { _state.state }
    
    
    public func executeNextStep() {
        let shouldIncrement = _state.shouldIncrement()
        if shouldIncrement {
            _stackpointer &+= 2
        }
        _state = _state.nextState
    }
}
