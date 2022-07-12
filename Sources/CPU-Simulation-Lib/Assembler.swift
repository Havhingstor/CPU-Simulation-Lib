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
    public var markers: [Marker]
    
    public var memoryValues: [UInt16: AddressValueType]
    
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
        private let value: UInt16
        
        public func transformOnlyNumber() -> String {
            transform()
        }
        
        public func transform() -> String {
            toDecString(unsignedToSigned(value))
        }
        
        public init(value: UInt16) {
            self.value = value
        }
    }
    
    public class AddressAddressValue: AddressValueType {
        private let value: UInt16
        
        public func transformOnlyNumber() -> String {
            transform()
        }
        
        public func transform() -> String {
            toLongHexString(value)
        }
        
        public init(value: UInt16) {
            self.value = value
        }
    }
    
    public class OpcodeAddressValue: AddressValueType {
        public func transformOnlyNumber() -> String {
            return toLongHexString(value)
        }
        
        private var value: UInt16 {
            UInt16(`operator`.operatorCode) + operandType.operandTypeCodePreparedForOpcode
        }
        
        public let `operator`: Operator
        
        public let operandType: AccessibleOperandType
        
        public func transform() -> String {
            `operator`.stringRepresentation + operandType.representationAddition
        }
        
        public init(`operator`: Operator, operandType: AccessibleOperandType) {
            self.operator = `operator`
            self.operandType = operandType
        }
    }
}

public protocol AddressValueType {
    func transform() -> String
    func transformOnlyNumber() -> String
}

public enum AssemblerErrors: Error {
    case OperatorNotDecodableError(`operator`: String, line: Int)
    case OperandNotDecodableError(operand: String, line: Int)
    case TooManyOperandsError(operand: String, line: Int)
    case WordValueMissingError(line: Int)
    case ProgramTooBigError
    case MarkerExistsTwiceError(marker: String, line: Int)
    case MarkerDoesntExistError(marker: String, line: Int)
}
