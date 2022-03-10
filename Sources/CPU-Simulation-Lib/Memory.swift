//
//  Memory.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation

public class Memory: CustomStringConvertible {
    private var memory: [UInt16]
    
    public init() {
        memory = Array(repeating: 0, count: 0x10000)
        addJumpbackSafetyGuard()
    }
    
    public var internalArray: [UInt16] {
        memory
    }
    
    public func write(_ value: UInt16, address: UInt16) {
        memory[Int(address)] = value
    }
    
    public func read(address: UInt16) -> UInt16 {
        memory[Int(address)]
    }
    
    public func reset() {
        memory = Array(repeating: 0, count: 0x10000)
        addJumpbackSafetyGuard()
    }
    
    public func writeValues(values: [UInt16]) throws {
        if arrayTooBig(values) {
            throw Errors.tooMuchValues
        }
        for i in 0 ..< values.count {
            memory[i] = values[i]
        }
    }
    
    public enum Errors: Error {
        case tooMuchValues
    }
    
    private func addJumpbackSafetyGuard() {
        memory[0xfffe] = 0xffff
        memory[0xffff] = 0xffff
    }
    
    private func arrayTooBig(_ array: [UInt16]) -> Bool {
        array.count > 0x10000
    }
}
