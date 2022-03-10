//
//  TablePrinter.swift
//  
//
//  Created by Paul on 10.03.22.
//

import Foundation

fileprivate func changeMaxNumberOfColumnsIfNeeded(_ row: [String], _ maxNumberOfColumns: Int) -> Int {
    if row.count > maxNumberOfColumns {
        return row.count
    }
    
    return maxNumberOfColumns
}

private func getMaxNumberOfColumns(values: [[String]]) -> Int {
    var maxNumberOfColumns = 0
    
    for row in values {
        maxNumberOfColumns = changeMaxNumberOfColumnsIfNeeded(row, maxNumberOfColumns)
    }
    
    return maxNumberOfColumns
}

fileprivate func testForEmptyColumns(_ maxNumberOfColumns: Int) -> Bool {
    return maxNumberOfColumns == 0
}

fileprivate func getEmptyArrayForMaxWidthPerColumn(_ maxNumberOfColumns: Int) -> [Int] {
    return Array(repeating: 0, count: maxNumberOfColumns)
}

fileprivate func testIfRowHasEntryInColumn(_ row: [String], columnNr: Int) -> Bool {
    return row.count > columnNr
}

private func testIfMaxWidthInColumnNeedsToBeUpdated(row: [String], columnNr: Int, maxWidthPerColumnArray: [Int]) -> Bool {
    row[columnNr].count > maxWidthPerColumnArray[columnNr]
}

private func updateMaxWidthInColumn(row: [String], columnNr: Int, maxWidthPerColumnArray: inout [Int]) {
    maxWidthPerColumnArray[columnNr] = row[columnNr].count
}

fileprivate func updateMaxWidthInColumnIfNeeded(row: [String], columnNr prevColumnNr: Int, maxWidthPerColumnArray: inout [Int], unifiedDistance: Bool) {
    var columnNr = prevColumnNr
    
    if unifiedDistance {
        columnNr = 0
    }
    
    if testIfRowHasEntryInColumn(row, columnNr: columnNr) {
        if  testIfMaxWidthInColumnNeedsToBeUpdated(row: row, columnNr: columnNr, maxWidthPerColumnArray: maxWidthPerColumnArray) {
            updateMaxWidthInColumn(row: row, columnNr: columnNr, maxWidthPerColumnArray: &maxWidthPerColumnArray)
        }
    }
}

fileprivate func applyUnifiedDistanceOnAllColumns(maxWidthPerColumn: inout [Int], maxNumberOfColumns: Int) {
    let dist = maxWidthPerColumn[0]
    maxWidthPerColumn = Array(repeating: dist, count: maxNumberOfColumns)
}

fileprivate func computeMaxWidthInAllColumnsCombined(_ maxWidthPerColumn: [Int], _ additionalDistance: UInt32) -> Int {
    var maxWidth = 0
    
    for i in maxWidthPerColumn {
        maxWidth += i + Int(additionalDistance)
    }
    
    return maxWidth
}

fileprivate func createResultStringWithHeaders(_ headerList: [String], _ maxWidthPerColumn: [Int], _ additionalDistance: UInt32) -> String {
    var result = ""
    
    for i in 0 ..< headerList.count {
        result += headerList[i].padding(toLength: maxWidthPerColumn[i] + Int(additionalDistance), withPad: " ", startingAt: 0)
    }
    
    result += "\n"
    
    return result
}

private func getHeaderDelimiter(maxWidth: Int) -> String {
    "".padding(toLength: maxWidth, withPad: "-", startingAt: 0) + "\n"
}

fileprivate func getFormattedValue( value: String, maxWidth: Int, additionalDistance: UInt32) -> String {
    return value.padding(toLength: maxWidth + Int(additionalDistance), withPad: " ", startingAt: 0)
}

fileprivate func appendRestOfValuesAfterFirstRow(values: [[String]], result: inout String, maxWidthPerColumn: inout [Int], additionalDistance: UInt32) {
    for row in 1 ..< values.count {
        let stringsInRow = values[row]
        for column in 0 ..< stringsInRow.count {
            result += getFormattedValue(value: stringsInRow[column], maxWidth: maxWidthPerColumn[column], additionalDistance: additionalDistance)
        }
        
        result += "\n"
    }
}

public func getTable(values: [[String]], header: Bool, additionalDistance: UInt32, unifiedDistance: Bool) -> String {
    let maxNumberOfColumns = getMaxNumberOfColumns(values: values)
    
    if testForEmptyColumns(maxNumberOfColumns) {
        return "\n"
    }
    
    var maxWidthPerColumn = getEmptyArrayForMaxWidthPerColumn(maxNumberOfColumns)
    
    let rangeOfColumnNrs = 0 ..< maxNumberOfColumns
    for i in rangeOfColumnNrs {
        for row in values {
            updateMaxWidthInColumnIfNeeded(row: row, columnNr: i, maxWidthPerColumnArray: &maxWidthPerColumn, unifiedDistance: unifiedDistance)
        }
    }
    
    if unifiedDistance {
        applyUnifiedDistanceOnAllColumns(maxWidthPerColumn: &maxWidthPerColumn, maxNumberOfColumns: maxNumberOfColumns)
    }
    
    let maxWidth = computeMaxWidthInAllColumnsCombined(maxWidthPerColumn, additionalDistance)
    
    let headerList = values[0]
    
    var result = createResultStringWithHeaders(headerList, maxWidthPerColumn, additionalDistance)
    
    if header {
        result += getHeaderDelimiter(maxWidth: maxWidth)
    }
    
    appendRestOfValuesAfterFirstRow(values: values, result: &result, maxWidthPerColumn: &maxWidthPerColumn, additionalDistance: additionalDistance)
    
    return result
}

