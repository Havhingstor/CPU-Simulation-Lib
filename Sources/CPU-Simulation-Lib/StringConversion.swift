//
//  StringConversion.swift
//  
//
//  Created by Paul on 10.03.22.
//

import Foundation
import CPU_Simulation_Utilities

extension Memory {
    
    public var description: String {
        getHexString()
    }
    
    public func getString() -> String {
        var result = "Memory:\n"
        
        let usedLines = calculateUsedLines()
        
        if usedLines.isEmpty {
            result += "No Values"
            return result
        }
        
        let table = createTable(usedLines)
        
        result += getTable(values: table, header: true, additionalDistance: 2, unifiedDistance: true)
        
        return result
    }
    
    public func getHexString() -> String {
        var result = "Memory:\n"
        
        let usedLines = calculateUsedLines()
        
        if usedLines.isEmpty {
            result += "No Values"
            return result
        }
        
        let table = createHexTable(usedLines)
        
        result += getTable(values: table, header: true, additionalDistance: 2, unifiedDistance: true)
        
        return result
    }
    
    private func getStartOfTable() -> [[String]] {
        return [["","0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]]
    }
    
    private func calculateUsedLines() -> [UInt16] {
        var usedLines: [UInt16] = []
        
        for i in 0 ... UInt16(0xffff) {
            let val = i & 0xFFF0
            if read(address: i) != 0 && !usedLines.contains(val) {
                usedLines.append(val)
            }
        }
        
        return usedLines
    }
    
    private func createFirstAddressFromLineNr(_ i: UInt16) -> UInt16 {
        return i << 4
    }
    
    private func testIfLineWasUsed(usedLines: [UInt16], lineNr: UInt16) -> Bool {
        return usedLines.contains(lineNr)
    }
    
    private func createStartOfNewLine(_ firstAddressNr: UInt16) -> [String] {
        return [toHexString(firstAddressNr)]
    }
    
    private func calculateAddressFromLineAndNr(lineNr: UInt16, address: UInt16) -> UInt16 {
        return lineNr | address
    }
    
    private func getStringOfAddress(lineNr: UInt16, address: UInt16) -> String {
        return String(read(address: calculateAddressFromLineAndNr(lineNr: lineNr, address: address)))
    }
    
    private func getHexStringOfAddress(lineNr: UInt16, address: UInt16) -> String {
        return toLongHexString(read(address: calculateAddressFromLineAndNr(lineNr: lineNr, address: address)))
    }
    
    fileprivate func addAddressToLine(line: inout [String], lineNr: UInt16, address: UInt16) {
        line.append(getStringOfAddress(lineNr: lineNr, address: address))
    }
    
    fileprivate func addAddressToLineAsHex(line: inout [String], lineNr: UInt16, address: UInt16) {
        line.append(getHexStringOfAddress(lineNr: lineNr, address: address))
    }
    
    fileprivate func handleUsageOfLastLineInResultString(lastLineUsed:  Bool, result: inout [[String]]) {
        if lastLineUsed {
            let addition: [String] = Array(repeating: "...", count: 17)
            result.append(addition)
        }
    }
    
    fileprivate func appendUsedLine(firstAddressNr: UInt16, result: inout [[String]]) {
        var newLine = createStartOfNewLine(firstAddressNr)
        
        for j in 0 ... UInt16(0xf) {
            addAddressToLine(line: &newLine, lineNr: firstAddressNr, address: j)
        }
        
        result.append(newLine)
    }
    
    fileprivate func appendUsedLineAsHex(firstAddressNr: UInt16, result: inout [[String]]) {
        var newLine = createStartOfNewLine(firstAddressNr)
        
        for j in 0 ... UInt16(0xf) {
            addAddressToLineAsHex(line: &newLine, lineNr: firstAddressNr, address: j)
        }
        
        result.append(newLine)
    }
    
    private func createTable(_ usedLines: [UInt16]) -> [[String]] {
        var result = getStartOfTable()
        var lastLineUsed = true
        
        for i in 0 ... UInt16(0xfff) {
            let firstAddressNr = createFirstAddressFromLineNr(i)
            
            if testIfLineWasUsed(usedLines: usedLines, lineNr: firstAddressNr) {
                appendUsedLine(firstAddressNr: firstAddressNr, result: &result)
                lastLineUsed = true
            } else {
                handleUsageOfLastLineInResultString(lastLineUsed: lastLineUsed, result: &result)
                lastLineUsed = false
            }
        }
        
        return result
    }
    
    private func createHexTable(_ usedLines: [UInt16]) -> [[String]] {
        var result = getStartOfTable()
        var lastLineUsed = true
        
        for i in 0 ... UInt16(0xfff) {
            let firstAddressNr = createFirstAddressFromLineNr(i)
            
            if testIfLineWasUsed(usedLines: usedLines, lineNr: firstAddressNr) {
                appendUsedLineAsHex(firstAddressNr: firstAddressNr, result: &result)
                lastLineUsed = true
            } else {
                handleUsageOfLastLineInResultString(lastLineUsed: lastLineUsed, result: &result)
                lastLineUsed = false
            }
        }
        
        return result
    }
}
