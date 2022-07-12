//
//  CPUStatesTests.swift
//  
//
//  Created by Paul on 09.02.22.
//

import XCTest
import CPU_Simulation_Lib
import CPU_Simulation_Utilities

class CPUStatesTests: XCTestCase {
    
    override func setUp() {
        StandardStates.startingState = NewStart.init
    }
    
    func testNewExternalState() {
        let memory = Memory()
        let cpu = CPU(memory: memory, startingPoint: 0x1b)
        XCTAssertEqual(cpu.state, "newState")
        
        XCTAssertNoThrow(try cpu.operateNextStep())
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 0x19)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.state, "newState")
        XCTAssertEqual(cpu.programCounter, 0x17)
    }
    
    func testNewStandardState() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.state, "newState")
        
        NewStart.standardNextState = AnotherState.init
        XCTAssertEqual(NewStart.standardNextState().state, AnotherState.state)
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.state, "anotherState")
        
        XCTAssertNoThrow(try cpu.operateNextStep())
        XCTAssertEqual(cpu.state, "newState")
        
        NewStart.resetStandardNextState()
        XCTAssertNoThrow(try cpu.operateNextStep())
        XCTAssertEqual(cpu.state, "newState")
    }
    
    func testNewStateChanged() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        XCTAssertEqual(cpu.state, "newState")
        
        NewStart.alternativeNextState = true // Affects the state after the next one
        NewStart.resetNextState = false
        
        XCTAssertNoThrow(try cpu.operateNextStep())
        XCTAssertEqual(cpu.state, "newState")
        
        XCTAssertNoThrow(try cpu.operateNextStep())
        XCTAssertEqual(cpu.state, "anotherState")
        
        NewStart.alternativeNextState = true // Affects the state after the next one
        NewStart.resetNextState = true
        
        XCTAssertNoThrow(try cpu.operateNextStep())
        XCTAssertEqual(cpu.state, "newState")
        
        XCTAssertNoThrow(try cpu.operateNextStep())
        XCTAssertEqual(cpu.state, "newState")
    }
    
    func testOperateOfHoldState() {
        let holdState = HoldState()
        
        let memory = Memory()
        let cpu = CPU(memory: memory)
        
        let result = holdState.operate(cpu: cpu.createCopy())
        
        XCTAssertEqual(result.accumulator, nil)
        XCTAssertEqual(result.vFlag, nil)
        XCTAssertEqual(result.addressBus, nil)
        XCTAssertEqual(result.dataBus, nil)
        XCTAssertEqual(result.stackpointer, nil)
        XCTAssertEqual(result.operand, nil)
        XCTAssertEqual(result.programCounter, nil)
        XCTAssertTrue(result.operandType == nil)
        XCTAssertTrue(result.`operator` == nil)
        
    }
    
    override class func tearDown() {
        StandardStates.resetStartingState()
    }
    
}

fileprivate class NewStart: CPUState {
    public let id: UUID = UUID()
    
    public static let standardNextStateProvider: StandardNextValueProvider<CPUState> = StandardNextValueProvider(builder: NewStart.init)
    
    //static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: NewStart.init)
    
    class var instructionEnded: Bool {true}
    
    class var state: String {"newState"}
    
    public static var alternativeNextState = false
    public static var resetNextState = false
    
    public init() {}
    
    
    public func operate(cpu: CPUCopy) -> NewCPUVars {
        let result = NewCPUVars()
        
        result.programCounter = cpu.programCounter &- 2
        
        if NewStart.alternativeNextState {
            Self.standardNextStateProvider.setNextValue(builder: AnotherState.init, uuid: id)
        }
        
        if NewStart.resetNextState {
            Self.standardNextStateProvider.resetNextValue(uuid: id)
        }
        
        return result
    }
}
    
fileprivate class AnotherState: CPUState {
    class var state: String {"anotherState"}
    
    public let id: UUID = UUID()
    
    public static let standardNextStateProvider: StandardNextValueProvider<CPUState> = StandardNextValueProvider(builder: NewStart.init)
    
    //static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: NewStart.init)
    
    class var instructionEnded: Bool {true}
    
    func operate(cpu: CPUCopy) -> NewCPUVars {
        NewCPUVars()
    }
    
    
}
