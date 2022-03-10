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
    
    func testCompleteExecutionWithExample() { // Example: Multiplicate two numbers (100 * 15), the result is written to memory address 5
        XCTAssertNoThrow(try memory.writeValues(values: [
            0x124, 0x6, 100, 15, 0x0, 0x0, 0x114, 0x3, 0x10F, 0x2,
            0x121, 0x18, 0x115, 0x4, 0x114, 0x2, 0x115, 0x3, 0x114, 0x4,
            0x115, 0x2, 0x114, 0x3, 0x115, 0x4, 0x114, 0x4, 0x122, 0x3C,
            0x120, 0x2E, 0x114, 0x5, 0x10A, 0x2, 0x115, 0x5, 0x114, 0x4,
            0x20B, 0x1, 0x115, 0x4, 0x124, 0x1A, 0x114, 0x5, 0x10B, 0x2,
            0x115, 0x5, 0x114, 0x4, 0x20A, 0x1, 0x115, 0x4, 0x124, 0x1A,
            0x63
        ]))
        
        XCTAssertNoThrow(try cpu.run())
        
        XCTAssertEqual(memory.read(address: 5), 1500)
        XCTAssertEqual(cpu.accumulator, 0)
        XCTAssertEqual(cpu.programCounter, 62)
    }
    
    func testRunWithCycleCounter() {
        XCTAssertEqual(cpu.cycleCount, 0)
        XCTAssertEqual(cpu.maxCycles, 100000)
        
        cpu.maxCycles = 1000
        XCTAssertEqual(cpu.maxCycles, 1000)
        
        memory.write(0, address: 0xfffe)    // Clear out the last two values
        memory.write(0, address: 0xffff)
        
        // Every memory-address holds 0, so that the cpu will forever execute NOOP-operations
        XCTAssertNoThrow(try cpu.run())
        
        XCTAssertEqual(cpu.cycleCount, 1000)
    }
    
    func testExecutionWithoutDecoding() {
        DecodedState.standardNextState = OperandFetchedState.init
        
        XCTAssertNoThrow(try cpu.endInstruction())
        
        
        DecodedState.resetStandardNextState()
    }
    
}
