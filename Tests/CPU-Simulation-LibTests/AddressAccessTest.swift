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
    
    func testDecodeAddressCode() throws {
        try memory.writeValues(values: [0x63, 0x100, 0x163, 0x100, 0x263, 0x100, 0x363, 0x100, 0x463, 0x100, 0x563, 0x100, 0x663, 0x100])
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.addressCode, 0)
        XCTAssertEqual(cpu.addressType.addressCode, cpu.addressCode)
        XCTAssertEqual(cpu.addressType.addressCodePreparedForOpcode, UInt16(cpu.addressCode) * 0x100)
        XCTAssertTrue(!cpu.addressType.providesInstantLiteral)
        XCTAssertTrue(!cpu.addressType.providesWriteAccess)
        XCTAssertTrue(cpu.addressType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.addressCode, 1)
        XCTAssertEqual(cpu.addressType.addressCode, cpu.addressCode)
        XCTAssertEqual(cpu.addressType.addressCodePreparedForOpcode, UInt16(cpu.addressCode) * 0x100)
        XCTAssertTrue(!cpu.addressType.providesInstantLiteral)
        XCTAssertTrue(cpu.addressType.providesWriteAccess)
        XCTAssertTrue(!cpu.addressType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.addressCode, 2)
        XCTAssertEqual(cpu.addressType.addressCode, cpu.addressCode)
        XCTAssertEqual(cpu.addressType.addressCodePreparedForOpcode, UInt16(cpu.addressCode) * 0x100)
        XCTAssertTrue(cpu.addressType.providesInstantLiteral)
        XCTAssertTrue(!cpu.addressType.providesWriteAccess)
        XCTAssertTrue(!cpu.addressType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.addressCode, 3)
        XCTAssertEqual(cpu.addressType.addressCode, cpu.addressCode)
        XCTAssertEqual(cpu.addressType.addressCodePreparedForOpcode, UInt16(cpu.addressCode) * 0x100)
        XCTAssertTrue(!cpu.addressType.providesInstantLiteral)
        XCTAssertTrue(cpu.addressType.providesWriteAccess)
        XCTAssertTrue(!cpu.addressType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.addressCode, 4)
        XCTAssertEqual(cpu.addressType.addressCode, cpu.addressCode)
        XCTAssertEqual(cpu.addressType.addressCodePreparedForOpcode, UInt16(cpu.addressCode) * 0x100)
        XCTAssertTrue(!cpu.addressType.providesInstantLiteral)
        XCTAssertTrue(cpu.addressType.providesWriteAccess)
        XCTAssertTrue(!cpu.addressType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.addressCode, 5)
        XCTAssertEqual(cpu.addressType.addressCode, cpu.addressCode)
        XCTAssertEqual(cpu.addressType.addressCodePreparedForOpcode, UInt16(cpu.addressCode) * 0x100)
        XCTAssertTrue(!cpu.addressType.providesInstantLiteral)
        XCTAssertTrue(cpu.addressType.providesWriteAccess)
        XCTAssertTrue(!cpu.addressType.isNothing)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.addressCode, 6)
        XCTAssertEqual(cpu.addressType.addressCode, cpu.addressCode)
        XCTAssertEqual(cpu.addressType.addressCodePreparedForOpcode, UInt16(cpu.addressCode) * 0x100)
        XCTAssertTrue(!cpu.addressType.providesInstantLiteral)
        XCTAssertTrue(!cpu.addressType.providesWriteAccess)
        XCTAssertTrue(!cpu.addressType.isNothing)
    }

    func testOwnAddressType() throws {
        CPUStandardVars.addressTypes.append(OwnAddressType.init)
        
        memory.write(0xff63, address: 0)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.addressType.addressCode, 0xff)
        XCTAssertTrue(cpu.addressType.providesInstantLiteral)
        XCTAssertTrue(cpu.addressType.providesWriteAccess)
        XCTAssertTrue(!cpu.addressType.isNothing)
        
        cpu.reset()
        CPUStandardVars.resetAddressTypes()
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.AddressCodeNotDecodable(address: 0, addressCode: 0xff))
        }
    }
    
}

fileprivate class OwnAddressType: AddressType {
    public static var providesWriteAccess: Bool { true }
    
    public static var readAccess: ReadAccess { .instantLiteralRead }
    
    static var addressCode: UInt8 { 0xff }
    
    public required init() {}
}
