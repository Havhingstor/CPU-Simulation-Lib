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
        StandardOperators.operators.append(OwnReadingOperator.init)
        StandardOperators.operators.append(OwnValueReadingOperator.init)
        StandardOperators.operators.append(OwnNothingOperator.init)
    }
    
    func testOperationInput() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        
        XCTAssertNoThrow(try memory.writeValues(values: [0x1ff,0x100,0x1fe,0x100,0xfd]))
        memory.write(0x555, address: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "READING")
        XCTAssertEqual(Self.executionInput.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(Self.executionInput.nFlag)
        XCTAssertTrue(!Self.executionInput.zFlag)
        XCTAssertTrue(!Self.executionInput.vFlag)
        XCTAssertEqual(Self.executionInput.operandValue!, 0x555)
        XCTAssertEqual(Self.underStackpointer, 0)
        XCTAssertEqual(cpu.stackpointer, 0xfffd)
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "VALUE-READING")
        XCTAssertEqual(Self.executionInput.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(Self.executionInput.nFlag)
        XCTAssertTrue(!Self.executionInput.zFlag)
        XCTAssertTrue(!Self.executionInput.vFlag)
        XCTAssertEqual(Self.executionInput.operandValue!, 0x555)
        XCTAssertEqual(Self.underStackpointer, 0)
        XCTAssertEqual(cpu.stackpointer, 0xfffc)
        XCTAssertEqual(cpu.addressBus, 0x100)
        XCTAssertEqual(cpu.dataBus, 0x555)
        
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "NOTHING")
        XCTAssertEqual(Self.executionInput.accumulator, signedToUnsigned(-50))
        XCTAssertTrue(Self.executionInput.nFlag)
        XCTAssertTrue(!Self.executionInput.zFlag)
        XCTAssertTrue(!Self.executionInput.vFlag)
        XCTAssertEqual(Self.executionInput.operandValue, nil)
        XCTAssertEqual(Self.underStackpointer, 0)
        XCTAssertEqual(cpu.stackpointer, 0xfffd)
    }
    
    func testBussesAfterIndirect() {
        let memory = Memory()
        let cpu = CPU(memory: memory)
        
        XCTAssertNoThrow(try memory.writeValues(values: [0x1fe,0x100,0x2fe,0x100,0x3fe,0x100,0x4fe,0x100,0x5fe,0x100,0x6fe,0x100]))
        memory.write(0x555, address: 0x100)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.addressBus, 0x100)
        XCTAssertEqual(cpu.dataBus, 0x555)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.addressBus, 0x555)
        XCTAssertEqual(cpu.dataBus, 0)
        
        var stackpointer = cpu.stackpointer
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.addressBus, stackpointer &+ 0x100)
        XCTAssertEqual(cpu.dataBus, 0)
        
        stackpointer = cpu.stackpointer
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.addressBus, 0)
        XCTAssertEqual(cpu.dataBus, 0x1fe)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.addressBus, nil)
        XCTAssertEqual(cpu.dataBus, nil)
    }
    
    override class func tearDown() {
        FetchedOperandToExecuteState.resetStandardNextState()
        StandardOperators.resetOperators()
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
        let stackpointer = input.stackpointer
        stackpointer--
        CPUExecutionInputTests.underStackpointer = stackpointer.underlyingValue
    }
    
    public required init() {}
    
}

private class OwnValueReadingOperator: Operator {
    static var requiresAddressOrWriteAccess: Bool {false}
    
    static var requiresLiteralReadAccess: Bool {false}
    
    static var operatorCode: UInt8 {0xfe}
    
    static var stringRepresentation: String {"VALUE-READING"}
    
    static var dontAllowOperandIfPossible: Bool {false}
    
    func operate(input: CPUExecutionInput) {
        CPUExecutionInputTests.executionInput = input
        _ = input.operandValue!
        let stackpointer = input.stackpointer
        stackpointer--
        CPUExecutionInputTests.underStackpointer = stackpointer.underlyingValue
    }
    
    public required init() {}
    
}

private class OwnNothingOperator: Operator {
    func operate(input: CPUExecutionInput) {
        CPUExecutionInputTests.executionInput = input
        let stackpointer = input.stackpointer
        stackpointer++
        CPUExecutionInputTests.underStackpointer = stackpointer.underlyingValue
    }
    
    static var requiresAddressOrWriteAccess: Bool {false}
    
    static var requiresLiteralReadAccess: Bool {false}
    
    static var operatorCode: UInt8 {0xfd}
    
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
