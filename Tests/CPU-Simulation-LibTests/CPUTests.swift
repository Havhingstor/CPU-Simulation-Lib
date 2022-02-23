//
//  CPUTests.swift
//  
//
//  Created by Paul on 09.02.22.
//

import XCTest
import CPU_Simulation_Lib

class CPUTests: XCTestCase {
    var memory: Memory = Memory()
    
    func testCreateCPU() {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.memory.internalArray, memory.internalArray)
    }
    
    func testProgramCounterAndNextStep() {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.programCounter, 0)
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.programCounter, 1)
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.programCounter, 1)
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.programCounter, 2)
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.programCounter, 2)
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.programCounter, 3)
    }
    
    func testprogramCounterInit() {
        let cpu = CPU(memory: memory, startingPoint: 10)
        XCTAssertEqual(cpu.programCounter, 10)
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.programCounter, 11)
    }
    
    func testNextStepOverflow() {
        let cpu = CPU(memory: memory, startingPoint: 0xffff)
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.programCounter, 0)
    }
    
    func testStates() {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.state, "hold")
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.state, "operator-fetched")
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.state, "decoded")
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.state, "operand-fetched")
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.state, "executed")
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.state, "operator-fetched")
    }
    
    func testEndInstruction() {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.state, "hold")
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.state, "executed")
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.state, "operator-fetched")
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.state, "executed")
    }
    
    func testFetchInstructions() {
        ExecutedToFetchOperatorState.standardNextState = StateBuilder(OwnDecode.init)
        XCTAssertNoThrow(try memory.writeValues(values: [1,2,3,4,5,6]))

        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.operand, 0)

        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 1)
        XCTAssertEqual(cpu.operand, 2)

        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.opcode, 3)
        XCTAssertEqual(cpu.operand, 4)

        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.opcode, 5)
        XCTAssertEqual(cpu.operand, 4)
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.opcode, 5)
        XCTAssertEqual(cpu.operand, 4)
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.opcode, 5)
        XCTAssertEqual(cpu.operand, 6)

        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.opcode, 5)
        XCTAssertEqual(cpu.operand, 6)
        
        ExecutedToFetchOperatorState.resetStandardNextState()
    }
    
    func testFetchDataBus() {
        memory.write(0x129, address: 0)
        let cpu = CPU(memory: memory)
        
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.addressBus, nil)
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.opcode, 0x129)
        XCTAssertEqual(cpu.addressBus, 0)
        XCTAssertEqual(cpu.dataBus, 0x129)
        
        XCTAssertNoThrow(try cpu.executeNextStep())
        XCTAssertEqual(cpu.opcode, 0x129)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
    }
    
    func testVarsAtStart() {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.lastMemoryInteraction, 0)
        XCTAssertTrue(!cpu.nFlag)
        XCTAssertTrue(!cpu.zFlag)
        XCTAssertTrue(!cpu.vFlag)
    }
}
