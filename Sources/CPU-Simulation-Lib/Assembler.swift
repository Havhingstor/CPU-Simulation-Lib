//
//  Assembler.swift
//  
//
//  Created by Paul on 10.03.22.
//

import Foundation
import CPU_Simulation_Utilities

private typealias Intern = AssemblerInternal

/// Reads assembly-code and loads it into memory
/// - Parameters:
///   - assemblyCode: The code which should be read
///   - memory: The memory in which the assembly-code should be loaded
/// - Returns: Returns a struct with additional information concerning markers and address-types
/// - Throws: Throws an error if parsing failed
public func assemble(assemblyCode: String, memory: Memory) throws -> AssemblingResults {
    
    let tokens = Intern.lex(assemblyCode)
    
    let parseResult = try Intern.parse(tokens: tokens)
    
    try Intern.applyParseResults(memory: memory, parseResult: parseResult)
    
    return Intern.createAssemblingResults(parseResults: parseResult)
}

/// A collection of additional information available after assembling
public struct AssemblingResults {
    /// A collection of the markers used
    public var markers: [Marker]
    
    /// An lookup-table of the types of values in a specific memory-address
    public var memoryValues: [UInt16: AddressValueType]
    
    /// A marker used in the assembly-code
    public struct Marker {
        
        /// The name of the marker
        public var name: String
        
        /// The address on which it points
        public var address: UInt16
        
        /// Whether the marker is for jumping or storage-purposes
        public var type: `Type`
        
        /// Whether the marker is for jumping or storage-purposes
        public enum `Type` {
            case variable
            case jumpMarker
            case undefined
        }
    }
       
    
    /// A number which is used literally, which should be formatted in decimal-format
    public class LiteralAddressValue: AddressValueType {
        private let value: UInt16
        
        public func transformOnlyNumber() -> String {
            transform()
        }
        
        public func transform() -> String {
            toDecString(unsignedToSigned(value))
        }
        
        /// Initializes the LiteralAddressValue
        /// - Parameter value: The value in the memory-address represented by the object
        public init(value: UInt16) {
            self.value = value
        }
    }
    
    /// A value referencing a memory-address, which should be formatted in hex-format
    public class AddressAddressValue: AddressValueType {
        private let value: UInt16
        
        public func transformOnlyNumber() -> String {
            transform()
        }
        
        public func transform() -> String {
            toLongHexString(value)
        }
        
        /// Initializes the AddressAddressValue
        /// - Parameter value: The value in the memory-address represented by the object
        public init(value: UInt16) {
            self.value = value
        }
    }
    
    /// A opcode, which should be represented by the operator or a hex-value
    public class OpcodeAddressValue: AddressValueType {
        public func transformOnlyNumber() -> String {
            return toLongHexString(value)
        }
        
        private var value: UInt16 {
            UInt16(`operator`.operatorCode) + operandType.operandTypeCodePreparedForOpcode
        }
        
        /// The operator represented by the value
        public let `operator`: Operator
        
        /// The operator-type represented by the value
        public let operandType: AccessibleOperandType
        
        public func transform() -> String {
            `operator`.stringRepresentation + operandType.representationAddition
        }
        
        /// Initializes the OpcodeAddressValue
        /// - Parameters:
        ///   - operator: The operator represented by the object
        ///   - operandType: The operand-type represented by the object
        public init(`operator`: Operator, operandType: AccessibleOperandType) {
            self.operator = `operator`
            self.operandType = operandType
        }
    }
}

/// A type of a specific value in memory, with functions for representing values
public protocol AddressValueType {
    /// Represents the stored value as a string, e. g. formatting the number, or transforming it into a opcode
    /// - Returns: The transformed value as a string
    func transform() -> String
    
    /// Represents the stored value in memory as a number, even if it would normally get displayed as a custom string.
    /// - Returns: The transformed value as a string of a number
    func transformOnlyNumber() -> String
}

/// The suite of errors which can occur while assembling
public enum AssemblerErrors: Error {
    /// The operator isn't present in the operator-list
    case OperatorNotDecodableError(`operator`: String, line: Int)
    /// The token following the operator isn't a operand
    case OperandNotDecodableError(operand: String, line: Int)
    /// The number of operands is greater than one
    case TooManyOperandsError(operand: String, line: Int)
    /// The operand after the word-operator is missing
    case WordValueMissingError(line: Int)
    /// The program doesn't fit in memory
    case ProgramTooBigError
    /// The marker  is declared twice
    case MarkerExistsTwiceError(marker: String, line: Int)
    /// The marker  isn't declared
    case MarkerDoesntExistError(marker: String, line: Int)
}
