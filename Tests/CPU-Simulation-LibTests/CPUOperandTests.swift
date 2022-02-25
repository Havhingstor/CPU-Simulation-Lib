//
//  CPUOperandTests.swift
//  
//
//  Created by Paul on 14.02.22.
//

import XCTest
import CPU_Simulation_Lib

class CPUOperandTests: XCTestCase {
    var memory = Memory()
    var cpu: CPU!
    
    override func setUp() {
        cpu = CPU(memory: memory)
    }
    
    func testDecodeOperandTypeCode() {
        XCTAssertNoThrow(try memory.writeValues(values: [0x63, 0x100, 0x10B, 0x100, 0x20B, 0x100, 0x30B, 0x100, 0x40B, 0x100, 0x50B, 0x100, 0x60B, 0x100]))
        XCTAssertEqual(cpu.operandTypeCode, 0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 0)
        XCTAssertEqual(cpu.operandType!.operandTypeCode, cpu.operandTypeCode)
        XCTAssertEqual(cpu.operandType!.operandTypeCodePreparedForOpcode, UInt16(cpu.operandTypeCode) * 0x100)
        XCTAssertTrue(!cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(!cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(cpu.operandType!.isNothing)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 1)
        XCTAssertEqual(cpu.operandType!.operandTypeCode, cpu.operandTypeCode)
        XCTAssertEqual(cpu.operandType!.operandTypeCodePreparedForOpcode, UInt16(cpu.operandTypeCode) * 0x100)
        XCTAssertTrue(!cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 2)
        XCTAssertEqual(cpu.operandType!.operandTypeCode, cpu.operandTypeCode)
        XCTAssertEqual(cpu.operandType!.operandTypeCodePreparedForOpcode, UInt16(cpu.operandTypeCode) * 0x100)
        XCTAssertTrue(cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(!cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 1)
        XCTAssertEqual(cpu.operandType!.operandTypeCode, cpu.operandTypeCode)
        XCTAssertEqual(cpu.operandType!.operandTypeCodePreparedForOpcode, UInt16(cpu.operandTypeCode) * 0x100)
        XCTAssertTrue(!cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 1)
        XCTAssertEqual(cpu.operandType!.operandTypeCode, cpu.operandTypeCode)
        XCTAssertEqual(cpu.operandType!.operandTypeCodePreparedForOpcode, UInt16(cpu.operandTypeCode) * 0x100)
        XCTAssertTrue(!cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 1)
        XCTAssertEqual(cpu.operandType!.operandTypeCode, cpu.operandTypeCode)
        XCTAssertEqual(cpu.operandType!.operandTypeCodePreparedForOpcode, UInt16(cpu.operandTypeCode) * 0x100)
        XCTAssertTrue(!cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 2)
        XCTAssertEqual(cpu.operandType!.operandTypeCode, cpu.operandTypeCode)
        XCTAssertEqual(cpu.operandType!.operandTypeCodePreparedForOpcode, UInt16(cpu.operandTypeCode) * 0x100)
        XCTAssertTrue(!cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(!cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
    }

    func testOwnOperandType() {
        StandardOperandTypes.operandTypes.append(OwnOperandType.init)
        
        memory.write(0xff0B, address: 0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandType!.operandTypeCode, 0xff)
        XCTAssertTrue(cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
        
        cpu.reset()
        StandardOperandTypes.resetOperandTypes()
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperandTypeCodeNotDecodable(address: 0, operandTypeCode: 0xff))
        }
    }
    
    func testChangeOfCoreOperandType() {
        XCTAssertNoThrow(try memory.writeValues(values: [0x314, 0x100 ]))
        
        XCTAssertEqual(IndirectAddressOperandType.standardCoreOperandType().operandTypeCode, 1)
        
        IndirectAddressOperandType.standardCoreOperandType = InstantLiteralOperandType.init
        XCTAssertEqual(IndirectAddressOperandType.standardCoreOperandType().operandTypeCode, 2)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 2)
        
        IndirectAddressOperandType.resetStandardCoreOperandType()
    }
    
}

fileprivate class OwnOperandType: AddressOperandType {
    override func getOperandValue(cpu: CPU) -> UInt16? {
        50
    }
    
    override public static var providesAddressOrWriteAccess: Bool { true }
    
    override public static var readAccess: ReadAccess { .instantLiteralRead }
    
    override static var operandTypeCode: UInt8 { 0xff }
}
