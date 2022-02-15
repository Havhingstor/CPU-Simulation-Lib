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
    
    func testprogramCounterAndNextStep() throws {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.programCounter, 0)
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 2)
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 2)
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 2)
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 4)
    }
    
    func testprogramCounterInit() throws {
        let cpu = CPU(memory: memory, startingPoint: 10)
        XCTAssertEqual(cpu.programCounter, 10)
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 12)
    }
    
    func testNextStepOverflow() throws {
        let cpu = CPU(memory: memory, startingPoint: 0xfffe)
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 0)
    }
    
    func testFlags() throws {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.state, "hold")
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "fetched")
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "decoded")
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "executed")
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "fetched")
    }
    
    func testEndInstruction() throws {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.state, "hold")
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.state, "executed")
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "fetched")
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.state, "executed")
    }
    
    func testFetchInstructions() throws {
        ExecutedToFetchState.standardNextState = StateBuilder(OwnDecode.init)
        try memory.writeValues(values: [1,2,3,4,5,6])

        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.operand, 0)

        try cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 1)
        XCTAssertEqual(cpu.operand, 2)

        try cpu.endInstruction()
        XCTAssertEqual(cpu.opcode, 3)
        XCTAssertEqual(cpu.operand, 4)

        try cpu.executeNextStep()
        XCTAssertEqual(cpu.opcode, 5)
        XCTAssertEqual(cpu.operand, 6)

        try cpu.executeNextStep()
        XCTAssertEqual(cpu.opcode, 5)
        XCTAssertEqual(cpu.operand, 6)
        ExecutedToFetchState.resetStandardNextState()
    }
    
    func testFetchDataBus() throws {
        memory.write(0x1000, address: 1)
        let cpu = CPU(memory: memory)
        
        XCTAssertEqual(cpu.dataBus, 0)
        XCTAssertEqual(cpu.addressBus, 0)
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.operand, 0x1000)
        XCTAssertEqual(cpu.addressBus, 1)
        XCTAssertEqual(cpu.dataBus, 0x1000)
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.operand, 0x1000)
        XCTAssertEqual(cpu.addressBus, 0)
        XCTAssertEqual(cpu.dataBus, 0)
    }
    
    func testVarsAtStart() {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertEqual(cpu.addressBus, 0)
        XCTAssertEqual(cpu.dataBus, 0)
        XCTAssertEqual(cpu.lastMemoryInteraction, 0)
    }
}
