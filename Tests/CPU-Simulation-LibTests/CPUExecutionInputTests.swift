//
//  CPUExecutionInputTests.swift
//  
//
//  Created by Paul on 17.02.22.
//

import XCTest
import CPU_Simulation_Lib
import CPU_Simulation_Utilities

class CPUExecutionInputTests: XCTestCase {
    static var executionInput: CPUExecutionInput!
    static var underStackpointer: UInt16 = 0
    
    override func setUp() {
        DecodedToFetchOperandState.standardNextState = StateBuilder(OwnExecutionState.init)
        CPUStandardVars.operators.append(OwnReadingOperator.init)
        CPUStandardVars.operators.append(OwnNothingOperator.init)
    }
    
    func testOperationInput() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        
        XCTAssertNoThrow(try memory.writeValues(values: [0x1ff,0x100,0xfe]))
        memory.write(0x555, address: 0x100)
        
        XCTAssertNoThrow(try! cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "READING")
        XCTAssertEqual(Self.executionInput.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(Self.executionInput.nFlag)
        XCTAssertTrue(!Self.executionInput.zFlag)
        XCTAssertTrue(!Self.executionInput.vFlag)
        XCTAssertEqual(Self.executionInput.operandValue!, 0x555)
        XCTAssertEqual(Self.underStackpointer, 0)
        XCTAssertEqual(cpu.stackpointer, 0xfffd)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "NOTHING")
        XCTAssertEqual(Self.executionInput.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(Self.executionInput.nFlag)
        XCTAssertTrue(!Self.executionInput.zFlag)
        XCTAssertTrue(!Self.executionInput.vFlag)
        XCTAssertEqual(Self.executionInput.operandValue, nil)
        XCTAssertEqual(Self.underStackpointer, 0xffff)
        XCTAssertEqual(cpu.stackpointer, 0xfffe)
    }
    
    override class func tearDown() {
        FetchedOperandToExecuteState.resetStandardNextState()
        CPUStandardVars.resetOperators()
    }
}

private class OwnReadingOperator: Operator {
    static var requiresAddressOrWriteAccess: Bool {false}
    
    static var requiresLiteralReadAccess: Bool {false}
    
    static var operatorCode: UInt8 {0xff}
    
    static var stringRepresentation: String {"READING"}
    
    static var dontAllowOperandIfPossible: Bool {false}
    
    func operate(input: CPUExecutionInput) {
        CPUExecutionInputTests.executionInput = input
        var stackpointer = input.stackpointer
        stackpointer--
        CPUExecutionInputTests.underStackpointer = stackpointer.underlyingValue
    }
    
    public required init() {}
    
}

private class OwnNothingOperator: Operator {
    func operate(input: CPUExecutionInput) {
        CPUExecutionInputTests.executionInput = input
        var stackpointer = input.stackpointer
        stackpointer++
        CPUExecutionInputTests.underStackpointer = stackpointer.underlyingValue
    }
    
    static var requiresAddressOrWriteAccess: Bool {false}
    
    static var requiresLiteralReadAccess: Bool {false}
    
    static var operatorCode: UInt8 {0xfe}
    
    static var stringRepresentation: String {"NOTHING"}
    
    static var dontAllowOperandIfPossible: Bool {true}
    
    public required init() {}
    
}

private class OwnExecutionState: CPUState {
    static var state: String {"OWN-EXECUTION"}
    
    static var standardNextStateProvider: StandardNextStateProvider = StandardNextStateProvider(original: StateBuilder(FetchedOperandToExecuteState.init))
    
    var nextStateProvider: SingleNextStateProvider {Self.standardNextStateProvider.getNewSingleNextStateProvider()}
    
    func operate(cpu: CPU) -> NewCPUVars {
        let result = NewCPUVars()
        
        result.accumulator = signedToUnsigned(-50)
        
        return result
    }
    
    class var instructionEnded: Bool { false }
    
}