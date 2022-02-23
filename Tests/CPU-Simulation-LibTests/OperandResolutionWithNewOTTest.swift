//
//  OperandResolutionWithNewOTTest.swift
//  
//
//  Created by Paul on 23.02.22.
//

import XCTest
import CPU_Simulation_Lib


class OperandResolutionWithNewOTTest: XCTestCase {

    var memory = Memory()
    var cpu: CPU!
    
    override func setUp() {
        cpu = CPU(memory: memory)
        FetchedOperatorToDecodeState.standardNextState = StateBuilder(OwnFetchOperandState.init)
    }
    
    func testOperandResolutionWithNewOperandType() {
        XCTAssertNoThrow(try memory.writeValues(values: [0x114, 0x100, 0x30A, 0x100]))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 2)
        XCTAssertEqual(cpu.operand, cpu.stackpointer &+ 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operandTypeCode, 2)
        XCTAssertEqual(cpu.operand, cpu.stackpointer &+ 0x100)
    }
    
    override class func tearDown() {
        FetchedOperatorToDecodeState.resetStandardNextState()
    }
    
}

private class OwnFetchOperandState: DecodedToFetchOperandState {
    override func operate(cpu: CPU) -> NewCPUVars {
        var result = NewCPUVars()
        result.operand = cpu.memory.read(address: cpu.programCounter)
        
        result.operandType = LiteralStackOperandType()
        
        resolveOperand(result: &result, cpu: cpu, operand: cpu.memory.read(address: cpu.programCounter))
        
        result.programCounter = cpu.programCounter &+ 1
        
        return result
    }
}
