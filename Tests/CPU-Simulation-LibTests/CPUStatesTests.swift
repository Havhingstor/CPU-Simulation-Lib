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
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 0x19)
        cpu.endInstruction()
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 0x17)
    }
    
    override func tearDown() {
        CPU.startingState = CPU.standardStartingState
    }
    
}

private class NewStart: CPUState {
    var instructionEnded: Bool {true}
    
    var state: String {"newState"}
    
    var nextState: CPUState {NewStart()}
    
    public func operate(cpu: CPU) -> NewCPUVars {
        let result = NewCPUVars()
        
        result.programCounter = cpu.programCounter &- 2
        
        return result
    }
}
