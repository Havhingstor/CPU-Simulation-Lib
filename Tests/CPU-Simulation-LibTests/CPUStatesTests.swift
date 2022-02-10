//
//  CPUStatesTests.swift
//  
//
//  Created by Paul on 09.02.22.
//

import XCTest
import CPU_Simulation_Lib

class CPUStatesTests: XCTestCase {
    
    func testNewExternalState() {
        CPU.startingState = NewStart()
        let memory = Memory()
        let cpu = CPU(memory: memory, startingPoint: 0x1b)
        XCTAssertEqual(cpu.state, "newState")
        cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "executed")
        XCTAssertEqual(cpu.programCounter, 0x1b)
    }
    
    override func tearDown() {
        CPU.startingState = CPU.standardStartingState
    }
    
}

private class NewStart: CPUState {
    var state: String {"newState"}
    
    var nextState: CPUState {StateExecuted()}
    
    func shouldIncrement() -> Bool {
        false
    }
    
    
}
