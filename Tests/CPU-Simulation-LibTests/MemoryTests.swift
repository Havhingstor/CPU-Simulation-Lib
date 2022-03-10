//
//  MemoryTests.swift
//  
//
//  Created by Paul on 09.02.22.
//

import XCTest
import CPU_Simulation_Lib

class MemoryTests: XCTestCase {
    var memory: Memory = Memory()
    
    func testMemory() {
        memory.write(10, address: 0)
        XCTAssertEqual(memory.read(address: 0), 10)
        
        memory.write(20, address: 1)
        XCTAssertEqual(memory.read(address: 0), 10)
        XCTAssertEqual(memory.read(address: 1), 20)
    }
    
    func testMemoryLoopbackSafetyGuard() {
        XCTAssertEqual(memory.read(address: 0xfffe), 0xffff)
        XCTAssertEqual(memory.read(address: 0xffff), 0xffff)
    }
    
    func testMemoryExtractArray() {
        memory.write(0xaaaa, address: 0xeeee)
        
        let memoryArray = memory.internalArray
        XCTAssertEqual(memoryArray[0xeeee], 0xaaaa)
    }
    
    func testMemoryReset() {
        memory.write(25, address: 0)
        XCTAssertEqual(memory.read(address: 0), 25)
        
        memory.reset()
        XCTAssertEqual(memory.read(address: 0), 0)
    }
    
    func testWriteValuesToMemory() {
        XCTAssertNoThrow(try memory.writeValues(values: [1,2,3,4,5,6]))
        XCTAssertEqual(memory.read(address: 0), 1)
        XCTAssertEqual(memory.read(address: 1), 2)
        XCTAssertEqual(memory.read(address: 2), 3)
        XCTAssertEqual(memory.read(address: 3), 4)
        XCTAssertEqual(memory.read(address: 4), 5)
        XCTAssertEqual(memory.read(address: 5), 6)
    }
    
    func testWriteTooMuchValues() {
        let values: [UInt16] = Array(repeating: UInt16(0), count: 0xaaaaa)
        XCTAssertThrowsError(try memory.writeValues(values: values)) { err in
            XCTAssertEqual(err as? Memory.Errors, Memory.Errors.tooMuchValues)
        }
    }
    
    func testMemoryToString() {
        XCTAssertNoThrow(try memory.writeValues(values: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,
                                                         0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,
                                                         0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]))
        
        XCTAssertGreaterThan(memory.description.count,0)
        print(memory)
    }
}
