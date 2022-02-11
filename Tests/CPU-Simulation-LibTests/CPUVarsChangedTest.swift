//
//  CPUVarsChangedTest.swift
//  
//
//  Created by Paul on 10.02.22.
//

import XCTest
import CPU_Simulation_Lib

class CPUVarsChangedTest: XCTestCase {

    override func setUp() {
        CPUStandardVars.startingState = StateBuilder(NewStart.init)
    }
    
    func testChangingVars() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        cpu.endInstruction()
        
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 1)
        XCTAssertEqual(cpu.accumulator, 2)
        XCTAssertEqual(cpu.stackpointer, 3)
        XCTAssertEqual(cpu.lastMemoryInteraction, 4)
        XCTAssertEqual(cpu.addressBus, 5)
        XCTAssertEqual(cpu.dataBus, 6)
        XCTAssertEqual(cpu.opcode, 7)
        XCTAssertEqual(cpu.referencedAddress, 8)
    }

    override func tearDown() {
        CPUStandardVars.resetStartingState()
    }
}

private class NewStart: CPUState {
    static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(NewStart.init))
    
    var nextStateProvider: SingleNextStateProvider = NewStart.standardNextStateProvider.getNewSingleNextStateProvider()
    
    var instructionEnded: Bool {true}
    
    var state: String {"newState"}
    
    public init() {}
    
    public func operate(cpu: CPU) -> NewCPUVars {
        let result = NewCPUVars()
        
        result.programCounter = 1
        result.accumulator = 2
        result.stackpointer = 3
        result.lastMemoryInteraction = 4
        result.addressBus = 5
        result.dataBus = 6
        result.opcode = 7
        result.referencedAddress = 8
        
        return result
    }
}