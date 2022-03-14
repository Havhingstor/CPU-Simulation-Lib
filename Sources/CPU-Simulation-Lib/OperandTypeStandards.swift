//
//  OperandTypeStandards.swift
//  
//
//  Created by Paul on 14.02.22.
//

import Foundation
import CPU_Simulation_Utilities

public class StandardOperandTypes {
    public typealias operandTypeInit = () -> AccessibleOperandType
    public static var operandTypes: [operandTypeInit] = standardOperandTypes
    public static func resetOperandTypes() {
        operandTypes = standardOperandTypes
    }
    
    public static func getOperandTypeAssignment() -> [UInt8 : operandTypeInit] {
        var result: [UInt8 : operandTypeInit] = [:]
        
        for operandTypeGenerator in operandTypes {
            addOperandTypeToAssignment(operandTypeGenerator: operandTypeGenerator, dict: &result)
        }
        
        return result
    }
    
    private static func addOperandTypeToAssignment(operandTypeGenerator: @escaping operandTypeInit, dict: inout [UInt8 : operandTypeInit]) {
        let operandType = operandTypeGenerator()
        dict.updateValue(operandTypeGenerator, forKey: operandType.operandTypeCode)
    }
    
    public static var standardOperandTypes: [operandTypeInit] { [
        AddressOperandType.init,
        LiteralOperandType.init,
        IndirectAddressOperandType.init,
        StackOperandType.init,
        IndirectStackOperandType.init,
        LiteralStackOperandType.init,
        NonexistingOperandType.init,
    ]}
    
    private static var standardIAppendedType: operandTypeInit { LiteralOperandType.init }
    
    public static var iAppendedType = standardIAppendedType
    
    public static func resetIAppendType() {
        iAppendedType = standardIAppendedType
    }
    
    private static var standardEmptyType: operandTypeInit { NonexistingOperandType.init }
    
    public static var emptyType = standardEmptyType
    
    public static func resetEmptyType() {
        emptyType = standardEmptyType
    }
}



private typealias Intern = OperandTypesInternal

open class AddressOperandType: CoreOperandType {
    
    open class var additionAtEnd: String { "" }
    open class var additionInFront: String { "" }
    open class var representationAddition: String { "" }
    
    public let id: UUID = UUID()
    
    open func resolveOperand(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        Intern.getStandardOperandResolutionResult(operand: oldOperand, cpu: cpu)
    }
    
    open func getOperandValue(cpu: CPUCopy) -> UInt16? {
        Intern.getOperandValueAddress(cpu: cpu)
    }
    
    open class var providesAddressOrWriteAccess: Bool { true }
    
    open class var readAccess: ReadAccess { .read }
    
    open class var operandTypeCode: UInt8 { 1 }
    
    public required init() {}
}

open class LiteralOperandType: CoreOperandType {
    
    open class var additionInFront: String { "$" }
    open class var additionAtEnd: String { "" }
    open class var representationAddition: String { "I" }
    
    public let id: UUID = UUID()
    
    open func resolveOperand(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        Intern.getStandardOperandResolutionResult(operand: oldOperand, cpu: cpu)
    }
    
    open func getOperandValue(cpu: CPUCopy) -> UInt16? {
        cpu.operand
    }
    
    open class var providesAddressOrWriteAccess: Bool { false }
    
    open class var readAccess: ReadAccess { .instantLiteralRead }
    
    open class var operandTypeCode: UInt8 { 2 }
    
    public required init() {}
}

open class IndirectLiteralOperandType: LiteralOperandType {
    override open class var readAccess: ReadAccess { .read }
    
    public required init() {}
}

open class IndirectAddressOperandType: AccessibleOperandType {
    
    open class var additionInFront: String { "(" }
    open class var additionAtEnd: String { ")" }
    open class var representationAddition: String { "@" }
    
    public static let standardCoreOperandTypeProvider: StandardNextValueProvider<CoreOperandType> = StandardNextValueProvider(builder: AddressOperandType.init)
    
    public let id: UUID = UUID()
    
    open func resolveOperand(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        Intern.getIndirectOperandResolutionResult(oldOperand: oldOperand, cpu: cpu)
    }
    
    open class var operandTypeCode: UInt8 { 3 }
    
    public required init() {}
}

open class StackOperandType: AccessibleOperandType {
    
    open class var additionInFront: String { "" }
    open class var additionAtEnd: String { "(SP)" }
    open class var representationAddition: String { "(SP)" }
    
    public static let standardCoreOperandTypeProvider: StandardNextValueProvider<CoreOperandType> = StandardNextValueProvider(builder: AddressOperandType.init)
    
    public let id: UUID = UUID()
    
    open func resolveOperand(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        Intern.getStackOperandResolutionResult(oldOperand: oldOperand, cpu: cpu)
    }
    
    open class var operandTypeCode: UInt8 { 4 }
    
    public required init() {}
}

open class IndirectStackOperandType: AccessibleOperandType {
    
    open class var additionInFront: String { "@" }
    open class var additionAtEnd: String { "(SP)" }
    open class var representationAddition: String { "@(SP)" }
    
    public static let standardCoreOperandTypeProvider: StandardNextValueProvider<CoreOperandType> = StandardNextValueProvider(builder: AddressOperandType.init)
    
    public let id: UUID = UUID()
    
    open func resolveOperand(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        Intern.getIndirectStackOperandResolutionResult(oldOperand: oldOperand, cpu: cpu)
    }
    
    open class var operandTypeCode: UInt8 { 5 }
    
    public required init() {}
}

open class LiteralStackOperandType: AccessibleOperandType {
    
    open class var additionInFront: String { "$" }
    open class var additionAtEnd: String { "(SP)" }
    open class var representationAddition: String { "I(SP)" }
    
    public static let standardCoreOperandTypeProvider: StandardNextValueProvider<CoreOperandType> = StandardNextValueProvider(builder: IndirectLiteralOperandType.init)
    
    public let id: UUID = UUID()
    
    open func resolveOperand(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        Intern.getLiteralStackOperandResolutionResult(oldOperand: oldOperand, cpu: cpu)
    }
    
    open class var operandTypeCode: UInt8 { 6 }
    
    public required init() {}
}

open class NonexistingOperandType: CoreOperandType {
    
    open class var additionAtEnd: String { "" }
    open class var additionInFront: String { "" }
    open class var representationAddition: String { "" }
    
    public let id: UUID = UUID()
    
    open func resolveOperand(oldOperand: UInt16, cpu: CPUCopy) -> OperandResolutionResult {
        OperandResolutionResult(operand: nil, addressBus: nil, dataBus: nil)
    }
    
    open func getOperandValue(cpu: CPUCopy) -> UInt16? {
        nil
    }
    
    open class var providesAddressOrWriteAccess: Bool { false }
    
    open class var readAccess: ReadAccess { .none }
    
    open class var operandTypeCode: UInt8 { 0 }
    
    public required init() {}
}
