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
    
    func testDecodeOperandCode() throws {
        try memory.writeValues(values: [0x63, 0x100, 0x163, 0x100, 0x263, 0x100, 0x363, 0x100, 0x463, 0x100, 0x563, 0x100, 0x663, 0x100])
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.operandCode, 0)
        XCTAssertEqual(cpu.operandType.operandCode, cpu.operandCode)
        XCTAssertEqual(cpu.operandType.operandCodePreparedForOpcode, UInt16(cpu.operandCode) * 0x100)
        XCTAssertTrue(!cpu.operandType.providesInstantLiteral)
        XCTAssertTrue(!cpu.operandType.providesWriteAccess)
        XCTAssertTrue(cpu.operandType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.operandCode, 1)
        XCTAssertEqual(cpu.operandType.operandCode, cpu.operandCode)
        XCTAssertEqual(cpu.operandType.operandCodePreparedForOpcode, UInt16(cpu.operandCode) * 0x100)
        XCTAssertTrue(!cpu.operandType.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType.providesWriteAccess)
        XCTAssertTrue(!cpu.operandType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.operandCode, 2)
        XCTAssertEqual(cpu.operandType.operandCode, cpu.operandCode)
        XCTAssertEqual(cpu.operandType.operandCodePreparedForOpcode, UInt16(cpu.operandCode) * 0x100)
        XCTAssertTrue(cpu.operandType.providesInstantLiteral)
        XCTAssertTrue(!cpu.operandType.providesWriteAccess)
        XCTAssertTrue(!cpu.operandType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.operandCode, 3)
        XCTAssertEqual(cpu.operandType.operandCode, cpu.operandCode)
        XCTAssertEqual(cpu.operandType.operandCodePreparedForOpcode, UInt16(cpu.operandCode) * 0x100)
        XCTAssertTrue(!cpu.operandType.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType.providesWriteAccess)
        XCTAssertTrue(!cpu.operandType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.operandCode, 4)
        XCTAssertEqual(cpu.operandType.operandCode, cpu.operandCode)
        XCTAssertEqual(cpu.operandType.operandCodePreparedForOpcode, UInt16(cpu.operandCode) * 0x100)
        XCTAssertTrue(!cpu.operandType.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType.providesWriteAccess)
        XCTAssertTrue(!cpu.operandType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.operandCode, 5)
        XCTAssertEqual(cpu.operandType.operandCode, cpu.operandCode)
        XCTAssertEqual(cpu.operandType.operandCodePreparedForOpcode, UInt16(cpu.operandCode) * 0x100)
        XCTAssertTrue(!cpu.operandType.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType.providesWriteAccess)
        XCTAssertTrue(!cpu.operandType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.operandCode, 6)
        XCTAssertEqual(cpu.operandType.operandCode, cpu.operandCode)
        XCTAssertEqual(cpu.operandType.operandCodePreparedForOpcode, UInt16(cpu.operandCode) * 0x100)
        XCTAssertTrue(!cpu.operandType.providesInstantLiteral)
        XCTAssertTrue(!cpu.operandType.providesWriteAccess)
        XCTAssertTrue(!cpu.operandType.isNothing)
    }

    func testOwnOperandType() throws {
        CPUStandardVars.operandTypes.append(OwnOperandType.init)
        
        memory.write(0xff63, address: 0)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.operandType.operandCode, 0xff)
        XCTAssertTrue(cpu.operandType.providesInstantLiteral)
        XCTAssertTrue(cpu.operandType.providesWriteAccess)
        XCTAssertTrue(!cpu.operandType.isNothing)
        
        cpu.reset()
        CPUStandardVars.resetOperandTypes()
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperandCodeNotDecodable(address: 0, operandCode: 0xff))
        }
    }
    
}

fileprivate class OwnOperandType: OperandType {
    public static var providesWriteAccess: Bool { true }
    
    public static var readAccess: ReadAccess { .instantLiteralRead }
    
    static var operandCode: UInt8 { 0xff }
    
    public required init() {}
}
