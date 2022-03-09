//
//  OperatorStandardsInternal.swift
//  
//
//  Created by Paul on 04.03.22.
//

import Foundation
import CPU_Simulation_Utilities

class OperatorStandardsInternal {
    typealias real = (UInt16, UInt16) -> UInt16
    typealias expected = (Int32, Int32) -> Int32
    
    static func calcMaths(real: real, expected: expected, input: CPUExecutionInput, result: inout CPUExecutionResult) {
        let prevAccu = input.accumulator
        let prevAccuSigned = convertForExpected(prevAccu)
        let operand = input.operandValue!
        let operandSigned = convertForExpected(operand)
        
        calcAndApplyResults(real: real, prevAccu, operand, expected: expected, prevAccuSigned, operandSigned, &result)
    }
    
    private static func calcAndApplyResults(real: real, _ prevAccu: UInt16, _ operand: UInt16, expected: expected, _ prevAccuSigned: Int32,
                                            _ operandSigned: Int32, _ result: inout CPUExecutionResult) {
        let realResult = real(prevAccu, operand)
        
        let expectedResult = expected(prevAccuSigned, operandSigned)
        
        result.accumulator = realResult
        
        applyVFlag(realResult, expectedResult, &result)
    }
    
    private static func compareResults(_ realResult: UInt16, _ expectedResult: Int32) -> Bool {
        unsignedToSigned(realResult) != expectedResult
    }
    
    private static func applyVFlag(_ realResult: UInt16, _ expectedResult: Int32, _ result: inout CPUExecutionResult) {
        if compareResults(realResult, expectedResult) {
            result.vFlag = true
        } else {
            result.vFlag = false
        }
    }
    
    static func convertForExpected(_ val: UInt16) -> Int32 {
        return Int32(unsignedToSigned(val))
    }
}
