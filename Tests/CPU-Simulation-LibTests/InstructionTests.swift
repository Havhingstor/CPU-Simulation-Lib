//
//  InstructionTests.swift
//  
//
//  Created by Paul on 12.02.22.
//

import XCTest
import CPU_Simulation_Lib

class InstructionTests: XCTestCase {
    var memory = Memory()
    var cpu: CPU!
    
    override func setUp() {
        cpu = CPU(memory: memory)
    }
    
    func testOperators() {
        try? memory.writeValues(values: [0x14, 0x100, 0x15, 0x200, 0xA, 0x100, 0xB, 0x100, 0xC, 0x100, 0xD, 0x100, 0xE, 0x100, 0xF, 0x100,
                                         0x28, 0x100, 0x29, 0x100, 0x2A, 0x100, 0x2B, 0x100, 0x2C, 0x100, 0x2D, 0x100, 0x1E, 0x100, 0x1F,
                                         0x100, 0x20, 0x100, 0x21, 0x100, 0x22, 0x100, 0x23, 0x100, 0x25, 0x100, 0x24, 0x100, 0x5, 0x100,
                                         0x7, 0x100, 0x8, 0x100, 0x0, 0x100, 0x63, 0x100, 0x1, 0x100, 0x2E, 0x100, 0x6, 0x100, 0x19, 0x100,
                                         0x1A, 0x100])
        
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.referencedAddress, 0)
        XCTAssertEqual(cpu.operatorString, "NOOP")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x14)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "LOAD")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x15)
        XCTAssertEqual(cpu.referencedAddress, 0x200)
        XCTAssertEqual(cpu.operatorString, "STORE")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0xA)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "ADD")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0xB)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "SUB")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0xC)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "MUL")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0xD)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "DIV")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0xE)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "MOD")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0xF)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "CMP")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x28)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "AND")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x29)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "OR")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x2A)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "XOR")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x2B)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "SHL")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x2C)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "SHR")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x2D)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "SHRA")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x1E)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPP")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x1F)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPNN")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x20)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPN")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x21)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPNP")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x22)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPZ")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x23)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPNZ")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x25)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMPV")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x24)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "JMP")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x5)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "JSR")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x7)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "RSV")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x8)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "REL")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x0)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "NOOP")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x63)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "HOLD")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x1)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "RESET")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x2E)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "NOT")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x6)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "RTS")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x19)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "PUSH")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x1A)
        XCTAssertEqual(cpu.referencedAddress, 0x100)
        XCTAssertEqual(cpu.operatorString, "POP")
    }
    
    func testDecodingError() {
        memory.write(0xff, address: 0)
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperatorCodeNotDecodable(address: 0, operatorCode: 0xff))
        }
    }
    
    func testDecodingOfOperatorCodeWhenInputWithAddressCode() {
        try? memory.writeValues(values: [0x100, 0, 0xAB14, 0, 0xFF0E])
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.operatorString, "NOOP")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0x100)
        XCTAssertEqual(cpu.currentOperator.operatorCode, 0)
        XCTAssertEqual(cpu.operatorString, "NOOP")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0xAB14)
        XCTAssertEqual(cpu.currentOperator.operatorCode, 0x14)
        XCTAssertEqual(cpu.operatorString, "LOAD")
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 0xFF0E)
        XCTAssertEqual(cpu.currentOperator.operatorCode, 0xE)
        XCTAssertEqual(cpu.operatorString, "MOD")
    }
    
    func testOwnInstruction() {
        CPUStandardVars.operators.append(OwnOperator.init)
        memory.write(0xff, address: 0)
        
        try? cpu.endInstruction()
        XCTAssertEqual(cpu.operatorString, "OWN")
        
        cpu.reset()
        CPUStandardVars.resetOperators()
         
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperatorCodeNotDecodable(address: 0, operatorCode: 0xff))
        }
    }
}

fileprivate class OwnOperator: Operator {
    static var operatorCode: UInt8 { 0xff }
    
    static var stringRepresentation: String {"OWN"}
    
    public required init() {}
}
