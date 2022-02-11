//
//  CPUStatesTests.swift
//  
//
//  Created by Paul on 09.02.22.
//

import XCTest
import CPU_Simulation_Lib

class CPUStatesTests: XCTestCase {
    
    override func setUp() {
        CPUStandardVars.startingState = StateBuilder(NewStart.init)
    }
    
    func testNewExternalState() {
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
    
    func testNewStandardState() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.state, "newState")
        
        NewStart.standardNextState = StateBuilder(AnotherState.init)
        XCTAssertEqual(NewStart.standardNextState, StateBuilder(AnotherState.init))
        cpu.endInstruction()
        XCTAssertEqual(cpu.state, "anotherState")
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "newState")
        
        NewStart.resetStandardNextState()
        cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "newState")
    }
    
    func testNewStateChanged() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.state, "newState")
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "newState")
        
        NewStart.alternativeNextState = true
        NewStart.resetNextState = false
        cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "anotherState")
        
        cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "newState")
        
        NewStart.alternativeNextState = true
        NewStart.resetNextState = true
        cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "newState")
    }
    
    override class func tearDown() {
        CPUStandardVars.resetStartingState()
    }
    
}

private class NewStart: CPUState {
    static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(NewStart.init))
    
    var nextStateProvider: SingleNextStateProvider = NewStart.standardNextStateProvider.getNewSingleNextStateProvider()
    
    var instructionEnded: Bool {true}
    
    var state: String {"newState"}
    
    public static var alternativeNextState = false
    public static var resetNextState = false
    
    public init() {}
    
    
    public func operate(cpu: CPU) -> NewCPUVars {
        let result = NewCPUVars()
        
        result.programCounter = cpu.programCounter &- 2
        
        if NewStart.alternativeNextState {
            nextStateProvider.nextState = StateBuilder(AnotherState.init)
        }
        
        if NewStart.resetNextState {
            nextStateProvider.resetNextState()
        }
        
        return result
    }
}
    
private class AnotherState: CPUState {
    var state: String {"anotherState"}
    
    static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(NewStart.init))
    
    var nextStateProvider: SingleNextStateProvider = AnotherState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    var instructionEnded: Bool {true}
    
    func operate(cpu: CPU) -> NewCPUVars {
        NewCPUVars()
    }
    
    
}