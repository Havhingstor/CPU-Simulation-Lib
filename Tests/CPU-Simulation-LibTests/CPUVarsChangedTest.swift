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
    
    func testChangingVars() throws {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        try cpu.endInstruction()
        
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 1)
        XCTAssertEqual(cpu.accumulator, 2)
        XCTAssertEqual(cpu.stackpointer, 3)
        XCTAssertEqual(cpu.lastMemoryInteraction, 4)
        XCTAssertEqual(cpu.addressBus, 5)
        XCTAssertEqual(cpu.dataBus, 6)
        XCTAssertEqual(cpu.opcode, 7)
        XCTAssertEqual(cpu.operand, 8)
    }
    
    func testReset() throws {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        NewStart.standardNextState = StateBuilder(ExecutedToFetchOperatorState.init)
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "executed")
        
        cpu.reset()
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 0)
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
        XCTAssertEqual(cpu.lastMemoryInteraction, 0)
        XCTAssertEqual(cpu.addressBus, 0)
        XCTAssertEqual(cpu.dataBus, 0)
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.operand, 0)
    }

    override func tearDown() {
        CPUStandardVars.resetStartingState()
    }
}

fileprivate class NewStart: CPUState {
    static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(NewStart.init))
    
    var nextStateProvider: SingleNextStateProvider = NewStart.standardNextStateProvider.getNewSingleNextStateProvider()
    
    class var instructionEnded: Bool {true}
    
    class var state: String {"newState"}
    
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
        result.operand = 8
        
        return result
    }
}
