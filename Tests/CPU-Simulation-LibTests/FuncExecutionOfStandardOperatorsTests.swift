//
//  CPUExecutionOfStandardOperatorsTest.swift
//  
//
//  Created by Paul on 03.03.22.
//

import XCTest
import CPU_Simulation_Lib
import CPU_Simulation_Utilities

class CPUExecutionOfStandardOperatorsTest: XCTestCase {

    var memory = Memory()
    var cpu: CPU!
    
    override func setUp() {
        cpu = CPU(memory: memory)
        StandardOperators.operators.append(PreparationOperator.init)
        
        XCTAssertNoThrow(try memory.writeValues(values: [0x1ff]))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        internalTestForPreparation()
    }
    
    func testNoop() {
        XCTAssertNoThrow(try cpu.endInstruction())
        internalTestForPreparation()
        XCTAssertEqual(cpu.operatorString, "NOOP")
    }
    
    func testLoad() {
        writeInstruction(newOperator: LOADOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        memory.write(512, address: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 512)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, 0x100)
        XCTAssertEqual(cpu.dataBus, 512)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testStore() {
        writeInstruction(newOperator: STOREOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, 0x100)
        XCTAssertEqual(cpu.dataBus, signedToUnsigned(-50))
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
        XCTAssertEqual(memory.read(address: 0x100), signedToUnsigned(-50))
    }
    
    func testAdd() {
        writeInstruction(newOperator: ADDOperator.self, operandType: LiteralOperandType.self, operand: 0x50)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0x1E)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testAddOverflow() {
        writeInstruction(newOperator: ADDOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-0x7fff))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0x7fcf)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testSUB() {
        writeInstruction(newOperator: SUBOperator.self, operandType: LiteralOperandType.self, operand: 50)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-100))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testSUBOverflow() {
        writeInstruction(newOperator: SUBOperator.self, operandType: LiteralOperandType.self, operand: 0x7fe2)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0x7fec)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testMUL() {
        writeInstruction(newOperator: MULOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-10))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 500)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testMULOverflow() {
        writeInstruction(newOperator: MULOperator.self, operandType: LiteralOperandType.self, operand: 1000)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0x3cb0)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testDIV() {
        writeInstruction(newOperator: DIVOperator.self, operandType: LiteralOperandType.self, operand: 25)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-2))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testDIVByZero() {
        writeInstruction(newOperator: DIVOperator.self, operandType: LiteralOperandType.self, operand: 0)
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUSimErrors, CPUSimErrors.DivisionByZero(operatorAddress: 2))
        }
    }
    
    func testDIVWithRemainder() {
        writeInstruction(newOperator: DIVOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-15))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(3))
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testMOD() {
        writeInstruction(newOperator: MODOperator.self, operandType: LiteralOperandType.self, operand: 15)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-5))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testMODByZero() {
        writeInstruction(newOperator: MODOperator.self, operandType: LiteralOperandType.self, operand: 0)
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUSimErrors, CPUSimErrors.DivisionByZero(operatorAddress: 2))
        }
    }
    
    func testCMP() {
        writeInstruction(newOperator: CMPOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-50))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testCMPOverflow() {
        writeInstruction(newOperator: CMPOperator.self, operandType: LiteralOperandType.self, operand: 0x7ff0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testAND() {
        writeInstruction(newOperator: ANDOperator.self, operandType: LiteralOperandType.self, operand: 0x89)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0x88)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testANDNegative() {
        writeInstruction(newOperator: ANDOperator.self, operandType: LiteralOperandType.self, operand: 0x8089)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0x8088)
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testOR() {
        writeInstruction(newOperator: OROperator.self, operandType: LiteralOperandType.self, operand: 0xff)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0xffff)
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testXOR() {
        writeInstruction(newOperator: XOROperator.self, operandType: LiteralOperandType.self, operand: 0x7fab)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0x8065)
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testSHL() {
        writeInstruction(newOperator: SHLOperator.self, operandType: LiteralOperandType.self, operand: 9)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0x9c00)
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testSHR() {
        writeInstruction(newOperator: SHROperator.self, operandType: LiteralOperandType.self, operand: 9)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0x7f)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testSHRA() {
        writeInstruction(newOperator: SHRAOperator.self, operandType: LiteralOperandType.self, operand: 9)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0xffff)
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPP() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: 100)
        writeInstruction(newOperator: JMPPOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 100)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 0x100)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPP_NegativeTest() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-100))
        writeInstruction(newOperator: JMPPOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-100))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPNN() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: 0)
        writeInstruction(newOperator: JMPNNOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 0x100)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPNN_NegativeTest() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-0x50))
        writeInstruction(newOperator: JMPNNOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-0x50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPN() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-0x50))
        writeInstruction(newOperator: JMPNOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-0x50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 0x100)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPN_NegativeTest() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: 100)
        writeInstruction(newOperator: JMPNOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 100)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPNP() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: 0)
        writeInstruction(newOperator: JMPNPOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 0x100)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPNP_NegativeTest() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: 100)
        writeInstruction(newOperator: JMPNPOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 100)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPZ() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: 0)
        writeInstruction(newOperator: JMPZOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 0x100)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPZ_NegativeTest() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-100))
        writeInstruction(newOperator: JMPZOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-100))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPNZ() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-100))
        writeInstruction(newOperator: JMPNZOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-100))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 0x100)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPNZ_NegativeTest() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: 0)
        writeInstruction(newOperator: JMPNZOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPV() {
        writeInstruction(newOperator: JMPVOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 0x100)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMPV_NegativeTest() {
        overwriteStart(newOperator: LOADOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-50))
        writeInstruction(newOperator: JMPVOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJMP() {
        writeInstruction(newOperator: JMPOperator.self, operandType: AddressOperandType.self, operand: 0x555)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 0x555)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testJSR() {
        writeInstruction(newOperator: JSROperator.self, operandType: AddressOperandType.self, operand: 0x555)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 0x555)
        XCTAssertEqual(cpu.addressBus, 0xfffd)
        XCTAssertEqual(cpu.dataBus, 4)
        XCTAssertEqual(cpu.stackpointer, 0xfffd)
        XCTAssertEqual(memory.read(address: 0xfffd), 4)
    }
    
    func testRSV() {
        writeInstruction(newOperator: RSVOperator.self, operandType: LiteralOperandType.self, operand: 0xd)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfff1)
    }
    
    func testRSVNegative() {
        writeInstruction(newOperator: RSVOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-1))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xffff)
    }
    
    func testRSVNegativeOverflow() {
        writeInstruction(newOperator: RSVOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-5))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 3)
    }
    
    func testREL() {
        overwriteStart(newOperator: RSVOperator.self, operandType: LiteralOperandType.self, operand: 0xd)
        writeInstruction(newOperator: RELOperator.self, operandType: LiteralOperandType.self, operand: 3)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfff4)
    }
    
    func testRELNegative() {
        overwriteStart(newOperator: RSVOperator.self, operandType: LiteralOperandType.self, operand: 0xd)
        writeInstruction(newOperator: RELOperator.self, operandType: LiteralOperandType.self, operand: signedToUnsigned(-1))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfff0)
    }
    
    func testRELOverflow() {
        overwriteStart(newOperator: RSVOperator.self, operandType: LiteralOperandType.self, operand: 0xd)
        writeInstruction(newOperator: RELOperator.self, operandType: LiteralOperandType.self, operand: 0x15)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 6)
    }
    
    func testHOLD() {
        writeInstruction(newOperator: HOLDOperator.self, operandType: NonexistingOperandType.self, operand: 0)
        
        XCTAssertNoThrow(try cpu.run())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
        XCTAssertEqual(cpu.state, "hold")
    }
    
    func testCPURunMethod() {
        writeInstruction(newOperator: ADDOperator.self, operandType: LiteralOperandType.self, operand: 110)
        writeInstruction(newOperator: DIVOperator.self, operandType: LiteralOperandType.self, operand: 20, startingAddress: 4)
        writeInstruction(newOperator: STOREOperator.self, operandType: AddressOperandType.self, operand: 0x100, startingAddress: 6)
        writeInstruction(newOperator: HOLDOperator.self, operandType: NonexistingOperandType.self, operand: 0, startingAddress: 8)
        
        XCTAssertNoThrow(try cpu.run())
        XCTAssertEqual(cpu.accumulator, 3)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 10)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
        XCTAssertEqual(memory.read(address: 0x100), 3)
        XCTAssertEqual(cpu.state, "hold")
    }
    
    func testRESET() {
        writeInstruction(newOperator: RESETOperator.self, operandType: NonexistingOperandType.self, operand: 0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 0)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
        
        XCTAssertEqual(cpu.state, "hold")
    }
    
    func testNOT() {
        writeInstruction(newOperator: NOTOperator.self, operandType: NonexistingOperandType.self, operand: 0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0x31)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    func testRTS() {
        writeInstruction(newOperator: RTSOperator.self, operandType: NonexistingOperandType.self, operand: 0)
        memory.write(0x100, address: 0xfffe)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 0x100)
        XCTAssertEqual(cpu.addressBus, 0xfffe)
        XCTAssertEqual(cpu.dataBus, 0x100)
        XCTAssertEqual(cpu.stackpointer, 0xffff)
    }
    
    func testPUSH() {
        writeInstruction(newOperator: PUSHOperator.self, operandType: NonexistingOperandType.self, operand: 0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, 0xfffd)
        XCTAssertEqual(cpu.dataBus, signedToUnsigned(-50))
        XCTAssertEqual(cpu.stackpointer, 0xfffd)
        XCTAssertEqual(memory.read(address: 0xfffd), signedToUnsigned(-50))
    }
    
    func testPOP() {
        writeInstruction(newOperator: POPOperator.self, operandType: NonexistingOperandType.self, operand: 0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0xffff)
        XCTAssertTrue(cpu.nFlag)
        XCTAssertTrue(!cpu.vFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertEqual(cpu.programCounter, 4)
        XCTAssertEqual(cpu.addressBus, 0xfffe)
        XCTAssertEqual(cpu.dataBus, 0xffff)
        XCTAssertEqual(cpu.stackpointer, 0xffff)
    }
    
    func testInternalFunc() {
        writeInstruction(newOperator: LOADOperator.self, operandType: AddressOperandType.self, operand: 0x100)
        
        XCTAssertEqual(memory.read(address: 2), 0x114)
        XCTAssertEqual(memory.read(address: 3), 0x100)
    }
    
    override class func tearDown() {
        StandardOperators.resetOperators()
    }
    
    private func internalTestForPreparation() {
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.vFlag)
        XCTAssertTrue(cpu.nFlag)
    }
    
    private func overwriteStart(newOperator: Operator.Type, operandType: AccessibleOperandType.Type, operand: UInt16) {
        cpu.reset()
        writeInstruction(newOperator: newOperator, operandType: operandType, operand: operand, startingAddress: 0)
        XCTAssertNoThrow(try cpu.endInstruction())
    }
    
    private func writeInstruction(newOperator: Operator.Type, operandType: AccessibleOperandType.Type, operand: UInt16, startingAddress: UInt16 = 2) {
        let opcode = UInt16(newOperator.operatorCode) | operandType.operandTypeCodePreparedForOpcode
        
        memory.write(opcode, address: startingAddress)
        memory.write(operand, address: startingAddress &+ 1)
    }
    
}

private class PreparationOperator: Operator {
    static var requiresAddressOrWriteAccess: Bool { false }
    
    static var requiresLiteralReadAccess: Bool { false }
    
    static var operatorCode: UInt8 {0xff}
    
    static var stringRepresentation: String {""}
    
    static var dontAllowOperandIfPossible: Bool { false }
    
    func execute(input: CPUExecutionInput) -> CPUExecutionResult {
        var result = CPUExecutionResult()
        
        result.accumulator = signedToUnsigned(-50)
        result.vFlag = true
        
        return result
    }
    
    required public init() {}
    
}
