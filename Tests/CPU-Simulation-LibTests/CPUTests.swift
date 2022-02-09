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
    
    override func setUp() {
        CPU.startingState = CPU.standardStartingState
    }
    
    func testCreateCPU() {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.memory.internalArray, memory.internalArray)
    }
    
    func testStackpointerAndNextStep() {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.stackpointer, 0)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.stackpointer, 2)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.stackpointer, 2)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.stackpointer, 2)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.stackpointer, 4)
    }
    
    func testStackpointerInit() {
        let cpu = CPU(memory: memory, startingPoint: 10)
        XCTAssertEqual(cpu.stackpointer, 10)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.stackpointer, 12)
    }
    
    func testNextStepOverflow() {
        let cpu = CPU(memory: memory, startingPoint: 0xfffe)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.stackpointer, 0)
    }
    
    func testFlags() {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.state, "hold")
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "fetched")
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "decoded")
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "executed")
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "fetched")
    }
}
