//
//  CPUStandardOperandTypes.swift
//  
//
//  Created by Paul on 14.02.22.
//

import Foundation

private typealias Intern = OperandTypesInternal

open class AddressOperandType: OperandType {
    open func getOperandValue(cpu: CPU) -> UInt16? {
        Intern.getOperandValueAddress(cpu: cpu)
    }
    
    open func getOperandAddress(cpu: CPU) -> UInt16? {
        cpu.operand
    }
    
    open class var providesAddressOrWriteAccess: Bool { true }
    
    open class var readAccess: ReadAccess { .read }
    
    open class var operandTypeCode: UInt8 { 1 }
    
    public required init() {}
}

open class LiteralOperandType: OperandType {
    open func getOperandValue(cpu: CPU) -> UInt16? {
        cpu.operand
    }
    
    open func getOperandAddress(cpu: CPU) -> UInt16? {
        nil
    }
    
    open class var providesAddressOrWriteAccess: Bool { false }
    
    open class var readAccess: ReadAccess { .instantLiteralRead }
    
    open class var operandTypeCode: UInt8 { 2 }
    
    public required init() {}
}

open class IndirectAddressOperandType: OperandType {
    open func getOperandValue(cpu: CPU) -> UInt16? {
        Intern.getIndirectOperandValueAddress(cpu: cpu)
    }
    
    open func getOperandAddress(cpu: CPU) -> UInt16? {
        cpu.memory.read(address: cpu.operand)
    }
    
    open class var providesAddressOrWriteAccess: Bool { true }
    
    open class var readAccess: ReadAccess { .read }
    
    open class var operandTypeCode: UInt8 { 3 }
    
    public required init() {}
}

open class StackOperandType: OperandType {
    open func getOperandValue(cpu: CPU) -> UInt16? {
        Intern.getOperandValueRelToStackpointer(cpu: cpu)
    }
    
    open func getOperandAddress(cpu: CPU) -> UInt16? {
        cpu.stackpointer &+ cpu.operand
    }
    
    open class var providesAddressOrWriteAccess: Bool { true }
    
    open class var readAccess: ReadAccess { .read }
    
    open class var operandTypeCode: UInt8 { 4 }
    
    public required init() {}
}

open class IndirectStackOperandType: OperandType {
    open func getOperandValue(cpu: CPU) -> UInt16? {
        Intern.getIndirectOperandValueRelToStackpointer(cpu: cpu)
    }
    
    open func getOperandAddress(cpu: CPU) -> UInt16? {
        cpu.memory.read(address: cpu.stackpointer &+ cpu.operand)
    }
    
    open class var providesAddressOrWriteAccess: Bool { true }
    
    open class var readAccess: ReadAccess { .read }
    
    open class var operandTypeCode: UInt8 { 5 }
    
    public required init() {}
}

open class LiteralStackOperandType: OperandType {
    open func getOperandValue(cpu: CPU) -> UInt16? {
        Intern.getOperandInRelationToStackpointer(cpu: cpu)
    }
    
    open func getOperandAddress(cpu: CPU) -> UInt16? {
        nil
    }
    
    open class var providesAddressOrWriteAccess: Bool { false }
    
    open class var readAccess: ReadAccess { .read }
    
    open class var operandTypeCode: UInt8 { 6 }
    
    public required init() {}
}

open class NonexistingOperandType: OperandType {
    open func getOperandValue(cpu: CPU) -> UInt16? {
        nil
    }
    
    open func getOperandAddress(cpu: CPU) -> UInt16? {
        nil
    }
    
    open class var providesAddressOrWriteAccess: Bool { false }
    
    open class var readAccess: ReadAccess { .none }
    
    open class var operandTypeCode: UInt8 { 0 }
    
    public required init() {}
}

extension CPUStandardVars {
    public static var standardOperandTypes: [operandTypeInit] { [
        AddressOperandType.init,
        LiteralOperandType.init,
        IndirectAddressOperandType.init,
        StackOperandType.init,
        IndirectStackOperandType.init,
        LiteralStackOperandType.init,
        NonexistingOperandType.init,
    ]}
}
