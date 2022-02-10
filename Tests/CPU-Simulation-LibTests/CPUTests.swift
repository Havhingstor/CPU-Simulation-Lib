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
    
    func testprogramCounterAndNextStep() {
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.programCounter, 0)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 2)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 2)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 2)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 4)
    }
    
    func testprogramCounterInit() {
        let cpu = CPU(memory: memory, startingPoint: 10)
        XCTAssertEqual(cpu.programCounter, 10)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 12)
    }
    
    func testNextStepOverflow() {
        let cpu = CPU(memory: memory, startingPoint: 0xfffe)
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.programCounter, 0)
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
