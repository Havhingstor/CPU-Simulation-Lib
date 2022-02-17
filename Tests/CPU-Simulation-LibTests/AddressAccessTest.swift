//
//  AddressAccessTest.swift
//  
//
//  Created by Paul on 14.02.22.
//

import XCTest
import CPU_Simulation_Lib

class AddressAccessTest: XCTestCase {
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
        XCTAssertEqual(cpu.operandTypeCode, 3)
        XCTAssertEqual(cpu.operandType!.operandTypeCode, cpu.operandTypeCode)
        XCTAssertEqual(cpu.operandType!.operandTypeCodePreparedForOpcode, UInt16(cpu.operandTypeCode) * 0x100)
        XCTAssertTrue(!cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 4)
        XCTAssertEqual(cpu.operandType!.operandTypeCode, cpu.operandTypeCode)
        XCTAssertEqual(cpu.operandType!.operandTypeCodePreparedForOpcode, UInt16(cpu.operandTypeCode) * 0x100)
        XCTAssertTrue(!cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 5)
        XCTAssertEqual(cpu.operandType!.operandTypeCode, cpu.operandTypeCode)
        XCTAssertEqual(cpu.operandType!.operandTypeCodePreparedForOpcode, UInt16(cpu.operandTypeCode) * 0x100)
        XCTAssertTrue(!cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 6)
        XCTAssertEqual(cpu.operandType!.operandTypeCode, cpu.operandTypeCode)
        XCTAssertEqual(cpu.operandType!.operandTypeCodePreparedForOpcode, UInt16(cpu.operandTypeCode) * 0x100)
        XCTAssertTrue(!cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(!cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
    }

    func testOwnOperandType() {
        CPUStandardVars.operandTypes.append(OwnOperandType.init)
        
        memory.write(0xff0B, address: 0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandType!.operandTypeCode, 0xff)
        XCTAssertTrue(cpu.operandType!.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType!.providesAddressOrWriteAccess)
        XCTAssertTrue(!cpu.operandType!.isNothing)
        
        cpu.reset()
        CPUStandardVars.resetOperandTypes()
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperandTypeCodeNotDecodable(address: 0, operandTypeCode: 0xff))
        }
    }
    
}

fileprivate class OwnOperandType: OperandType {
    public static var providesAddressOrWriteAccess: Bool { true }
    
    public static var readAccess: ReadAccess { .instantLiteralRead }
    
    static var operandTypeCode: UInt8 { 0xff }
    
    public required init() {}
}
