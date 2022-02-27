//
//  CPUExecutionTests.swift
//  
//
//  Created by Paul on 17.02.22.
//

import XCTest
import CPU_Simulation_Lib

class CPUExecutionTests: XCTestCase {
    
    var memory = Memory()
    var cpu: CPU!
    
    override func setUp() {
        cpu = CPU(memory: memory)
    }
    
    func testExecutionWithoutDecoding() {
        DecodedState.standardNextState = OperandFetchedState.init
        
        XCTAssertNoThrow(try cpu.endInstruction())
        
        
        DecodedState.resetStandardNextState()
    }
    
}
