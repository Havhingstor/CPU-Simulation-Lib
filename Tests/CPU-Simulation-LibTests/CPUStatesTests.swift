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
    
    func testNewExternalState() throws {
        let memory = Memory()
        let cpu = CPU(memory: memory, startingPoint: 0x1b)
        XCTAssertEqual(cpu.state, "newState")
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 0x19)
        
        try cpu.endInstruction()
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 0x17)
    }
    
    func testNewStandardState() throws {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.state, "newState")
        
        NewStart.standardNextState = StateBuilder(AnotherState.init)
        XCTAssertEqual(NewStart.standardNextState, StateBuilder(AnotherState.init))
        try cpu.endInstruction()
        XCTAssertEqual(cpu.state, "anotherState")
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "newState")
        
        NewStart.resetStandardNextState()
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "newState")
    }
    
    func testNewStateChanged() throws {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.state, "newState")
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "newState")
        
        NewStart.alternativeNextState = true
        NewStart.resetNextState = false
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "anotherState")
        
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "newState")
        
        NewStart.alternativeNextState = true
        NewStart.resetNextState = true
        try cpu.executeNextStep()
        XCTAssertEqual(cpu.state, "newState")
    }
    
    override class func tearDown() {
        CPUStandardVars.resetStartingState()
    }
    
}

fileprivate class NewStart: CPUState {
    static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(NewStart.init))
    
    var nextStateProvider: SingleNextStateProvider = NewStart.standardNextStateProvider.getNewSingleNextStateProvider()
    
    class var instructionEnded: Bool {true}
    
    class var state: String {"newState"}
    
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
    
fileprivate class AnotherState: CPUState {
    class var state: String {"anotherState"}
    
    static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(NewStart.init))
    
    var nextStateProvider: SingleNextStateProvider = AnotherState.standardNextStateProvider.getNewSingleNextStateProvider()
    
    class var instructionEnded: Bool {true}
    
    func operate(cpu: CPU) -> NewCPUVars {
        NewCPUVars()
    }
    
    
}
