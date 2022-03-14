//
//  OperatorStandards.swift
//  
//
//  Created by Paul on 12.02.22.
//

import Foundation
import CPU_Simulation_Utilities

public class StandardOperators {
    public typealias OperatorInit = () -> Operator
    public static var operators = standardOperators
    public static func resetOperators() {
        operators = standardOperators
    }
    
    
    public static var operatorAssemblyAdditions: [OperatorInit] = standardOperatorAssemblyAdditions
    public static func resetOperatorAssemblyAdditions() {
        operatorAssemblyAdditions = standardOperatorAssemblyAdditions
    }
    
    public static func getOperatorAssignment() -> [UInt8 : OperatorInit] {
        var result: [UInt8 : OperatorInit] = [:]
        
        for operatorGenerator in operators {
            addOperatorToAssignment(operatorGenerator: operatorGenerator, dict: &result)
        }
        
        return result
    }
    
    private static func addOperatorToAssignment(operatorGenerator: @escaping OperatorInit, dict: inout [UInt8 : OperatorInit]) {
        let op = operatorGenerator()
        dict.updateValue(operatorGenerator, forKey: op.operatorCode)
    }
    
    public static func getOperatorNameAssignment() -> [String : OperatorInit] {
        var result: [String : OperatorInit] = [:]
        
        for operatorGenerator in operators {
            addOperatorToNameAssignment(operatorGenerator: operatorGenerator, dict: &result)
        }
        
        for operatorGenerator in operatorAssemblyAdditions {
            addOperatorToNameAssignment(operatorGenerator: operatorGenerator, dict: &result)
        }
        
        return result
    }
    
    private static func addOperatorToNameAssignment(operatorGenerator: @escaping OperatorInit, dict: inout [String : OperatorInit]) {
        let op = operatorGenerator()
        dict.updateValue(operatorGenerator, forKey: op.stringRepresentation.lowercased())
    }
    
    public static var standardOperators: [OperatorInit] { [
        LOADOperator.init,
        STOREOperator.init,
        ADDOperator.init,
        SUBOperator.init,
        MULOperator.init,
        DIVOperator.init,
        MODOperator.init,
        CMPOperator.init,
        ANDOperator.init,
        OROperator.init,
        XOROperator.init,
        SHLOperator.init,
        SHROperator.init,
        SHRAOperator.init,
        JMPPOperator.init,
        JMPNNOperator.init,
        JMPNOperator.init,
        JMPNPOperator.init,
        JMPZOperator.init,
        JMPNZOperator.init,
        JMPVOperator.init,
        JMPOperator.init,
        JSROperator.init,
        RSVOperator.init,
        RELOperator.init,
        NOOPOperator.init,
        HOLDOperator.init,
        RESETOperator.init,
        NOTOperator.init,
        RTSOperator.init,
        PUSHOperator.init,
        POPOperator.init,
    ] }
    
    public static var standardOperatorAssemblyAdditions: [OperatorInit] { [
        JGTOperator.init,
        JGEOperator.init,
        JLTOperator.init,
        JLEOperator.init,
        JEQOperator.init,
        JNEOperator.init,
        JOVOperator.init,
        CALLOperator.init,
        RETURNOperator.init
    ]}
}

private typealias Intern = OperatorStandardsInternal

public class LOADOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = input.operandValue
        result.vFlag = false
        
        return result
    }
    
    open class var stringRepresentation: String {"LOAD"}
    public static var operatorCode: UInt8 {0x14}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class STOREOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.toWrite = input.accumulator
        
        return result
    }
    
    open class var stringRepresentation: String {"STORE"}
    public static var operatorCode: UInt8 {0x15}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { true }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class ADDOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        Intern.calcMaths(real: {$0 &+ $1}, expected: {$0 + $1}, input: input, result: &result)
        
        return result
    }
    
    open class var stringRepresentation: String {"ADD"}
    public static var operatorCode: UInt8 {0xA}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class SUBOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        Intern.calcMaths(real: {$0 &- $1}, expected: {$0 - $1}, input: input, result: &result)
        
        return result
    }
    
    open class var stringRepresentation: String {"SUB"}
    public static var operatorCode: UInt8 {0xB}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class MULOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        Intern.calcMaths(real: {$0 &* $1}, expected: {$0 * $1}, input: input, result: &result)
        
        return result
    }
    
    open class var stringRepresentation: String {"MUL"}
    public static var operatorCode: UInt8 {0xC}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class DIVOperator: Operator {
    public func execute(input: CPUExecutionInput) throws -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        guard input.operandValue != 0 else {
            throw CPUSimErrors.DivisionByZero(operatorAddress: input.operatorAddress)
        }
        
        result.accumulator = signedToUnsigned(unsignedToSigned(input.accumulator) / unsignedToSigned(input.operandValue!))
        result.vFlag = false
        
        return result
    }
    
    open class var stringRepresentation: String {"DIV"}
    public static var operatorCode: UInt8 {0xD}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class MODOperator: Operator {
    public func execute(input: CPUExecutionInput) throws -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        guard input.operandValue != 0 else {
            throw CPUSimErrors.DivisionByZero(operatorAddress: input.operatorAddress)
        }
        
        result.accumulator = signedToUnsigned(unsignedToSigned(input.accumulator) % unsignedToSigned(input.operandValue!))
        result.vFlag = false
        
        return result
    }
    
    open class var stringRepresentation: String {"MOD"}
    public static var operatorCode: UInt8 {0xE}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class CMPOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        let numResult = Intern.convertForExpected(input.accumulator) - Intern.convertForExpected(input.operandValue!)
        
        result.vFlag = false
        result.nFlag = numResult < 0
        result.zFlag = numResult == 0
        
        return result
    }
    
    open class var stringRepresentation: String {"CMP"}
    public static var operatorCode: UInt8 {0xF}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class ANDOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = input.accumulator & input.operandValue!
        result.vFlag = false
        
        return result
    }
    
    open class var stringRepresentation: String {"AND"}
    public static var operatorCode: UInt8 {0x28}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class OROperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = input.accumulator | input.operandValue!
        result.vFlag = false
        
        return result
    }
    
    open class var stringRepresentation: String {"OR"}
    public static var operatorCode: UInt8 {0x29}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class XOROperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = input.accumulator ^ input.operandValue!
        result.vFlag = false
        
        return result
    }
    
    open class var stringRepresentation: String {"XOR"}
    public static var operatorCode: UInt8 {0x2A}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class SHLOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = input.accumulator << input.operandValue!
        result.vFlag = false
        
        return result
    }
    
    open class var stringRepresentation: String {"SHL"}
    public static var operatorCode: UInt8 {0x2B}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class SHROperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = input.accumulator >> input.operandValue!
        result.vFlag = false
        
        return result
    }
    
    open class var stringRepresentation: String {"SHR"}
    public static var operatorCode: UInt8 {0x2C}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class SHRAOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        let signedPrevAccu = unsignedToSigned(input.accumulator)
        let signedOperand = unsignedToSigned(input.operandValue!)
        
        let signedResult = signedPrevAccu >> signedOperand
        
        result.accumulator = signedToUnsigned(signedResult)
        result.vFlag = false
        
        return result
    }
    
    open class var stringRepresentation: String {"SHRA"}
    public static var operatorCode: UInt8 {0x2D}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JMPPOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        if !(input.nFlag || input.zFlag) {
            result.programCounter = input.operand!
        }
        
        return result
    }
    
    open class var stringRepresentation: String {"JMPP"}
    public static var operatorCode: UInt8 {0x1E}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { true }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JGTOperator: JMPPOperator {
    open class override var stringRepresentation: String { "JGT" }
}

public class JMPNNOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        if !input.nFlag {
            result.programCounter = input.operand!
        }
        
        return result
    }
    
    open class var stringRepresentation: String {"JMPNN"}
    public static var operatorCode: UInt8 {0x1F}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { true }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JGEOperator: JMPNNOperator {
    open class override var stringRepresentation: String { "JGE" }
}

public class JMPNOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        if input.nFlag {
            result.programCounter = input.operand!
        }
        
        return result
    }
    
    open class var stringRepresentation: String {"JMPN"}
    public static var operatorCode: UInt8 {0x20}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { true }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JLTOperator: JMPNOperator {
    open class override var stringRepresentation: String { "JLT" }
}

public class JMPNPOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        if input.nFlag || input.zFlag {
            result.programCounter = input.operand
        }
        
        return result
    }
    
    open class var stringRepresentation: String {"JMPNP"}
    public static var operatorCode: UInt8 {0x21}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { true }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JLEOperator: JMPNPOperator {
    open class override var stringRepresentation: String { "JLE" }
}

public class JMPZOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        if input.zFlag {
            result.programCounter = input.operand
        }
        
        return result
    }
    
    open class var stringRepresentation: String {"JMPZ"}
    public static var operatorCode: UInt8 {0x22}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { true }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JEQOperator: JMPZOperator {
    open class override var stringRepresentation: String { "JEQ" }
}

public class JMPNZOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        if !input.zFlag {
            result.programCounter = input.operand
        }
        
        return result
    }
    
    open class var stringRepresentation: String {"JMPNZ"}
    public static var operatorCode: UInt8 {0x23}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { true }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JNEOperator: JMPNZOperator {
    open class override var stringRepresentation: String { "JNE" }
}

public class JMPVOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        if input.vFlag {
            result.programCounter = input.operand
        }
        
        return result
    }
    
    open class var stringRepresentation: String {"JMPV"}
    public static var operatorCode: UInt8 {0x25}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { true }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JOVOperator: JMPVOperator {
    open class override var stringRepresentation: String { "JOV" }
}

public class JMPOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.programCounter = input.operand
        
        return result
    }
    
    open class var stringRepresentation: String {"JMP"}
    public static var operatorCode: UInt8 {0x24}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { true }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JSROperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.programCounter = input.operand
        input.stackpointer--
        input.stackpointer.underlyingValue = input.programCounter
        
        return result
    }
    
    open class var stringRepresentation: String {"JSR"}
    public static var operatorCode: UInt8 {0x5}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { true }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class CALLOperator: JSROperator {
    open class override var stringRepresentation: String { "CALL" }
}

public class RSVOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        for _ in 0 ..< input.operandValue! {
            input.stackpointer--
        }
        
        return CPUExecutionResult()
    }
    
    open class var stringRepresentation: String {"RSV"}
    public static var operatorCode: UInt8 {0x7}
    
    public static var requiresLiteralReadAccess: Bool { true }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class RELOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        for _ in 0 ..< input.operandValue! {
            input.stackpointer++
        }
        
        return CPUExecutionResult()
    }
    
    open class var stringRepresentation: String {"REL"}
    public static var operatorCode: UInt8 {0x8}
    
    public static var requiresLiteralReadAccess: Bool { true }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class NOOPOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        return CPUExecutionResult()
    }
    
    open class var stringRepresentation: String {"NOOP"}
    public static var operatorCode: UInt8 {0x0}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class HOLDOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.continuation = .hold
        
        return result
    }
    
    open class var stringRepresentation: String {"HOLD"}
    public static var operatorCode: UInt8 {0x63}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class RESETOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.continuation = .reset
        
        return result
    }
    
    open class var stringRepresentation: String {"RESET"}
    public static var operatorCode: UInt8 {0x1}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class NOTOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = ~input.accumulator
        result.vFlag = false
        
        return result
    }
    
    open class var stringRepresentation: String {"NOT"}
    public static var operatorCode: UInt8 {0x2E}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class RTSOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.programCounter = input.stackpointer.underlyingValue
        input.stackpointer++
        
        return result
    }
    
    open class var stringRepresentation: String {"RTS"}
    public static var operatorCode: UInt8 {0x6}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class RETURNOperator: RTSOperator {
    open class override var stringRepresentation: String { "RETURN" }
}

public class PUSHOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        input.stackpointer--
        input.stackpointer.underlyingValue = input.accumulator
        
        return CPUExecutionResult()
    }
    
    open class var stringRepresentation: String {"PUSH"}
    public static var operatorCode: UInt8 {0x19}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class POPOperator: Operator {
    public func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = input.stackpointer.underlyingValue
        result.vFlag = false
        
        input.stackpointer++
        
        return result
    }
    
    open class var stringRepresentation: String {"POP"}
    public static var operatorCode: UInt8 {0x1A}
    
    public static var requiresLiteralReadAccess: Bool { false }
    public static var requiresAddressOrWriteAccess: Bool { false }
    public static var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}
