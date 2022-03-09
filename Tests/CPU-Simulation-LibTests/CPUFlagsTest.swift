//
//  CPUFlagsTest.swift
//  
//
//  Created by Paul on 17.02.22.
//

import XCTest
import CPU_Simulation_Lib
import CPU_Simulation_Utilities

class CPUFlagsTest: XCTestCase {
    
    var memory = Memory()
    var cpu: CPU!
    
    override func setUp() {
        cpu = CPU(memory: memory)
    }
    
    func testZFlag() {
        OperandFetchedState.standardNextState = ZTestState.init
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 1)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertTrue(cpu.zFlag)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, 1)
        XCTAssertTrue(!cpu.zFlag)
        
        OperandFetchedState.resetStandardNextState()
    }
    
    func testZFlagAtStart() {
        OperandFetchedState.standardNextState = ZTestNothingDoingState.init
        
        XCTAssertTrue(!cpu.zFlag)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertTrue(!cpu.zFlag)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertTrue(!cpu.zFlag)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertTrue(!cpu.zFlag)
        
        OperandFetchedState.standardNextState = ZTestState.init
        
        XCTAssertNoThrow(try cpu.endInstruction())
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertTrue(cpu.zFlag)
        
        
        OperandFetchedState.resetStandardNextState()
    }
    
    func testNFlag() {
        OperandFetchedState.standardNextState = NTestState.init
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(cpu.nFlag)
        
        OperandFetchedState.standardNextState = ZTestState.init
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.accumulator, signedToUnsigned(0))
        XCTAssertTrue(!cpu.nFlag)
        
        OperandFetchedState.resetStandardNextState()
    }
}

private class ZTestState: ExecutedState {
    override func operate(cpu: CPUCopy) -> NewCPUVars {
        let result = NewCPUVars()
        
        if cpu.accumulator == 0 {
            result.accumulator = 1
        } else {
            result.accumulator = 0
        }
        
        return result
    }
}

private class ZTestNothingDoingState: ExecutedState {
    override func operate(cpu: CPUCopy) -> NewCPUVars {
        NewCPUVars()
    }
}

private class NTestState: ExecutedState {
    override func operate(cpu: CPUCopy) -> NewCPUVars {
        let result = NewCPUVars()
        
        result.accumulator = signedToUnsigned(-50)
        
        return result
    }
}
