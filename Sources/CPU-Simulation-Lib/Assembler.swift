//
//  Assembler.swift
//  
//
//  Created by Paul on 10.03.22.
//

import Foundation
import CPU_Simulation_Utilities

private typealias Intern = AssemblerInternal

public func assemble(assemblyCode: String, memory: Memory) throws -> AssemblingResults {
    
    let tokens = Intern.lex(assemblyCode)
    
    let parseResult = try Intern.parse(tokens: tokens)
    
    try Intern.applyParseResults(memory: memory, parseResult: parseResult)
    
    return Intern.createAssemblingResults(parseResults: parseResult)
}

public struct AssemblingResults {
    public var markers: [Marker] = []
    
    public var memoryValues: [UInt16: AddressValueType] = [:]
    
    public struct Marker {
        public var name: String
        public var address: UInt16
        public var type: `Type`
        
        public enum `Type` {
            case variable
            case jumpMarker
            case undefined
        }
    }
       
    
    public class LiteralAddressValue: AddressValueType {
        public func transform(value: UInt16) -> String {
            toDecString(unsignedToSigned(value))
        }
        
        public init() {}
    }
    
    public class AddressAddressValue: AddressValueType {
        public func transform(value: UInt16) -> String {
            toLongHexString(value)
        }
        
        public init() {}
    }
    
    public class OpcodeAddressValue: AddressValueType {
        public var `operator`: Operator
        public var operandType: AccessibleOperandType
        
        public func transform(value: UInt16) -> String {
            `operator`.stringRepresentation + operandType.representationAddition
        }
        
        public init(`operator`: Operator, operandType: AccessibleOperandType) {
            self.operator = `operator`
            self.operandType = operandType
        }
    }
}

public protocol AddressValueType {
    func transform(value: UInt16) -> String
}

public enum AssemblerErrors: Error {
    case OperatorNotDecodableError(`operator`: String, line: Int)
    case OperandNotDecodableError(operand: String, line: Int)
    case OperandNotAllowedError(operand: String, line: Int)
    case OperandMissing(`operator`: String, line: Int)
    case ProgramTooBigError
    case MarkerExistsTwiceError(marker: String, line: Int)
    case MarkerDoesntExistError(marker: String, line: Int)
}
