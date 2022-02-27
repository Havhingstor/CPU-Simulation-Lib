//
//  CreateOperatorCodeTests.swift
//  
//
//  Created by Paul on 12.02.22.
//

import XCTest
import CPU_Simulation_Lib

class CreateOperatorCodeTests: XCTestCase {
    var memory = Memory()
    var cpu: CPU!
    
    override func setUp() {
        cpu = CPU(memory: memory)
    }
    
    func testCreationOfOperatorCodes() {
        XCTAssertEqual(LOADOperator.operatorCode, 0x14)
        XCTAssertEqual(OROperator.operatorCode, 0x29)
        XCTAssertEqual(NOOPOperator.operatorCode, 0)
        XCTAssertEqual(HOLDOperator.operatorCode, 0x63)
    }
    
    func testOwnOperatorCode() {
        StandardOperators.operators.append(OwnOperator.init)
        memory.write(UInt16(OwnOperator.operatorCode), address: 0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 0xAB)
        XCTAssertEqual(cpu.operatorString, "OWN")
    }
}

fileprivate class OwnOperator: Operator {
    func execute(input: CPUExecutionInput) {
        
    }
    
    static var operatorCode: UInt8 { 0xAB }
    
    static var stringRepresentation: String { "OWN" }
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { true }
    
    required public init() {}
}
