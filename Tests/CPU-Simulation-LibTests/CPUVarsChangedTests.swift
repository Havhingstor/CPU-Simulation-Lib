//
//  CPUVarsChangedTest.swift
//  
//
//  Created by Paul on 10.02.22.
//

import XCTest
import CPU_Simulation_Lib
import CPU_Simulation_Utilities

class CPUVarsChangedTest: XCTestCase {

    override func setUp() {
        StandardStates.startingState = NewStart.init
    }
    
    func testChangingVars() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        XCTAssertNoThrow(try cpu.endInstruction())
        
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 1)
        XCTAssertEqual(cpu.accumulator, 2)
        XCTAssertEqual(cpu.stackpointer, 3)
        XCTAssertEqual(cpu.lastMemoryInteraction, 4)
        XCTAssertEqual(cpu.addressBus, 5)
        XCTAssertEqual(cpu.dataBus, 6)
        XCTAssertEqual(cpu.opcode, 7)
        XCTAssertEqual(cpu.operand, 8)
        XCTAssertTrue(cpu.vFlag)
    }
    
    func testReset() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        NewStart.standardNextState = OpcodeFetchedState.init
        
        XCTAssertNoThrow(try cpu.operateNextStep())
        XCTAssertEqual(cpu.state, "opcode-fetched")
        
        cpu.reset()
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 0)
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
        XCTAssertEqual(cpu.lastMemoryInteraction, 0)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.operand, 0)
    }
    
    func testResetWithewStartingPoint() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        NewStart.standardNextState = OpcodeFetchedState.init
        
        XCTAssertNoThrow(try cpu.operateNextStep())
        XCTAssertEqual(cpu.state, "opcode-fetched")
        
        cpu.reset(startingPoint: 50)
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 50)
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
        XCTAssertEqual(cpu.lastMemoryInteraction, 0)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.operand, 0)
    }
    
    func testResetWithNewMaxCycles() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        NewStart.standardNextState = OpcodeFetchedState.init
        
        XCTAssertNoThrow(try cpu.operateNextStep())
        XCTAssertEqual(cpu.state, "opcode-fetched")
        
        cpu.reset(maxCycles: 50)
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 0)
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
        XCTAssertEqual(cpu.lastMemoryInteraction, 0)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        XCTAssertEqual(cpu.opcode, 0)
        XCTAssertEqual(cpu.operand, 0)
        XCTAssertEqual(cpu.maxCycles, 50)
    }

    func testStartingOperatorString() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.operatorString, "NOOP")
        
        StandardCPUVars.startingOperatorString = "START"
        XCTAssertEqual(cpu.operatorString, "START")
        
        StandardCPUVars.resetStartingOperatorString()
        XCTAssertEqual(cpu.operatorString, "NOOP")
    }
    
    override func tearDown() {
        StandardStates.resetStartingState()
    }
}

fileprivate class NewStart: CPUState {
    public let id: UUID = UUID()
    
    public static let standardNextStateProvider: StandardNextValueProvider<CPUState> = StandardNextValueProvider(builder: NewStart.init)
    
    //static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: NewStart.init)
    
    class var instructionEnded: Bool {true}
    
    class var state: String {"newState"}
    
    public init() {}
    
    public func operate(cpu: CPUCopy) -> NewCPUVars {
        let result = NewCPUVars()
        
        result.programCounter = 1
        result.accumulator = 2
        result.stackpointer = 3
        result.lastMemoryInteraction = 4
        result.addressBus = 5
        result.dataBus = 6
        result.opcode = 7
        result.operand = 8
        result.vFlag = true
        
        return result
    }
}
