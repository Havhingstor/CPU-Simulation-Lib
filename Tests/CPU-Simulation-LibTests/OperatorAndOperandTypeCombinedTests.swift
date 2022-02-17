//
//  OperatorAndOperandTypeCombinedTests.swift
//  
//
//  Created by Paul on 15.02.22.
//

import XCTest
import CPU_Simulation_Lib

class OperatorAndOperandTypeCombinedTests: XCTestCase {
    var memory = Memory()
    var cpu: CPU!
    
    override func setUp() {
        cpu = CPU(memory: memory)
    }
    
    func testForAddress() {
        XCTAssertNoThrow(try memory.writeValues(values: [ 0x114, 0x100, 0x10E, 0x100, 0x11E, 0x100, 0x107, 0x100]))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "LOAD")
        XCTAssertEqual(cpu.operandTypeCode, 1)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "MOD")
        XCTAssertEqual(cpu.operandTypeCode, 1)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "JMPP")
        XCTAssertEqual(cpu.operandTypeCode, 1)
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperatorRequiresInstantLiteralOperandAccess(address: 6, operatorCode: 7, operandTypeCode: 1))
        }
        
        XCTAssertNoThrow(try memory.writeValues(values: [0x163, 0x100]))
        cpu.reset()
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperatorAllowsNoOperand(address: 0, operatorCode: 0x63, operandTypeCode: 1))
        }
    }

    func testForLiteral() {
        XCTAssertNoThrow(try memory.writeValues(values: [ 0x214, 0x100, 0x20E, 0x100, 0x207, 0x100, 0x21E, 0x100]))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "LOAD")
        XCTAssertEqual(cpu.operandTypeCode, 2)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "MOD")
        XCTAssertEqual(cpu.operandTypeCode, 2)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "RSV")
        XCTAssertEqual(cpu.operandTypeCode, 2)
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperatorRequiresAddressOrWriteAccess(address: 6, operatorCode: 0x1E, operandTypeCode: 2))
        }
        
        XCTAssertNoThrow(try memory.writeValues(values: [0x263, 0x100]))
        cpu.reset()
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperatorAllowsNoOperand(address: 0, operatorCode: 0x63, operandTypeCode: 2))
        }
    }
    
    func testForIndirect() {
        XCTAssertNoThrow(try memory.writeValues(values: [ 0x314, 0x100, 0x30E, 0x100, 0x31E, 0x100, 0x307, 0x100]))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "LOAD")
        XCTAssertEqual(cpu.operandTypeCode, 3)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "MOD")
        XCTAssertEqual(cpu.operandTypeCode, 3)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "JMPP")
        XCTAssertEqual(cpu.operandTypeCode, 3)
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperatorRequiresInstantLiteralOperandAccess(address: 6, operatorCode: 7, operandTypeCode: 3))
        }
        
        XCTAssertNoThrow(try memory.writeValues(values: [0x363, 0x100]))
        cpu.reset()
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperatorAllowsNoOperand(address: 0, operatorCode: 0x63, operandTypeCode: 3))
        }
    }
    
    func testForNoOperand() {
        XCTAssertNoThrow(try memory.writeValues(values: [0, 0, 0x63, 0, 0x14, 0x100]))
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "NOOP")
        XCTAssertEqual(cpu.operandTypeCode, 0)
        
        XCTAssertNoThrow(try cpu.endInstruction())
        XCTAssertEqual(cpu.operatorString, "HOLD")
        XCTAssertEqual(cpu.operandTypeCode, 0)
        
        XCTAssertThrowsError(try cpu.endInstruction()) { err in
            XCTAssertEqual(err as? CPUErrors, CPUErrors.OperatorRequiresExistingOperand(address: 4, operatorCode: 0x14, operandTypeCode: 0))
        }
    }
}
