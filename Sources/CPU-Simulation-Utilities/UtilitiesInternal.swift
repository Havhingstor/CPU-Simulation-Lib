//
//  UtilitiesInternal.swift
//  
//
//  Created by Paul on 09.02.22.
//

import Foundation

let decimalCharSet = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-"]
let binaryCharSet = ["0", "1", "-"]
let hexadecimalCharSet = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "-"]

func stringIsLongEnough(_ string: String, _ fillLength: Int) -> Bool {
    return string.count < fillLength
}

func addZeroToStartOfString(string: String) -> String {
    "0" + string
}

func fillStringWithZeroes(string: String, fillLength: Int) -> String {
    var result = string
    
    while stringIsLongEnough(result, fillLength) {
        result = addZeroToStartOfString(string: result)
    }
    
    return result
}

func addWhitespacesToNumberString(_ numberString: String, charsInGroup: Int) -> String {
    var result = ""
    
    for i in getReverseStringIndexes(numberString) {
        addCharOfOriginAndWhitespaceIfNeededToString(&result, origin: numberString, index: i, charsInGroup: charsInGroup)
    }
    
    return removeWhitespacesAtStartAndEnd(result)
}

func removeWhitespacesAtStartAndEnd(_ string: String) -> String {
    string.trimmingCharacters(in: .whitespaces)
}

func addCharOfOriginAndWhitespaceIfNeededToString(_ string: inout String, origin: String, index i: Int, charsInGroup: Int) {
    string = getReverseCharOfString(origin, index: i) + string
    string = addWhitespaceIfGroupHasEnded(string, index: i, charsInGroup: charsInGroup)
}

func addWhitespaceIfGroupHasEnded(_ string: String, index i: Int, charsInGroup: Int) -> String {
    if dividableThrough(i, charsInGroup) {
        return " " + string
    }
    return string
}

func dividableThrough(_ i: Int, _ charsInGroup: Int) -> Bool {
    return i % charsInGroup == 0
}

func getReverseCharOfString(_ string: String, index i: Int) -> String {
    let offset = string.count - i
    return String(string[String.Index(utf16Offset: offset, in: string)])
}

func getReverseStringIndexes(_ string: String) -> ClosedRange<Int> {
    1 ... string.count
}

func getHexPositiveRepresentationOfNumber(_ number: Int16) -> String {
    let positiveNumber = abs(number)
    return toHexString(positiveNumber)
}

func getHexPositiveRepresentationOfNumberFilledWithZero(_ number: Int16) -> String {
    fillStringWithZeroes(string: getHexPositiveRepresentationOfNumber(number), fillLength: 4)
}

func getBinPositiveRepresentationOfNumber(_ number: Int16) -> String {
    let positiveNumber = abs(number)
    return toBinString(positiveNumber)
}

func getBinPositiveRepresentationOfNumberFilledWithZero(_ number: Int16) -> String {
    fillStringWithZeroes(string: getBinPositiveRepresentationOfNumber(number), fillLength: 16)
}

func getMinusIfNegative(_ number: Int16) -> String {
    number < 0 ? "-" : ""
}

func lowercasedCharIsInCharset(_ charSet: [String], _ character: String.Element) -> Bool {
    return charSet.contains(String(character).lowercased())
}

func goThroughCharsAndTestIfInCharset(_ number: String, charSet: [String]) -> Bool {
    var allowed = true
    for character in number {
        if !lowercasedCharIsInCharset(charSet, character) {
            allowed = false
        }
    }
    return allowed
}

func guaranteeNumberInCharSet(_ number: String, charSet: [String]) throws {
    if !goThroughCharsAndTestIfInCharset(number, charSet: charSet) {
        throw UtilityErrors.NoNumber
    }
}

func guaranteeDecimalNumber(_ number: String) throws {
    try guaranteeNumberInCharSet(number, charSet: decimalCharSet)
}

func guaranteeHexadecimalNumber(_ number: String) throws {
    try guaranteeNumberInCharSet(number, charSet: hexadecimalCharSet)
}

func guaranteeBinaryNumber(_ number: String) throws {
    try guaranteeNumberInCharSet(number, charSet: binaryCharSet)
}

func removePrefixOfString(_ val: String, prefix: String) -> String {
    var cleanedString = val
    
    cleanedString = removePrefixOfStringWithoutDealingWithMinus(cleanedString, prefix: prefix)
    cleanedString = removePrefixOfStringAfterMinusIfNeeded(cleanedString, prefix: prefix)
    
    return cleanedString
}

func removePrefixOfStringWithoutDealingWithMinus(_ val: String, prefix: String) -> String {
    var cleanedStr = val
    
    if val.starts(with: prefix) {
        cleanedStr = removeFirstNChars(val, n: prefix.count)
    }
    
    return cleanedStr
}

func removePrefixOfStringAfterMinusIfNeeded(_ val: String, prefix: String) -> String {
    var cleanedStr = val
    
    if val.starts(with: "-" + prefix) {
        cleanedStr = replacePrefixAfterMinus(val, prefix: prefix)
    }
    
    return cleanedStr
}

func replacePrefixAfterMinus(_ val: String, prefix: String) -> String {
    let numberOfCharsToRemove = prefix.count + 1
    let strWithoutMinus = removeFirstNChars(val, n: numberOfCharsToRemove)
    let strWithMinus = "-" + strWithoutMinus
    return strWithMinus
}

func removeFirstNChars(_ val: String, n: Int) -> String {
    var result = val
    
    for _ in 0 ..< n {
        result = String(result.dropFirst())
    }
    
    return result
}

func convertNegativeSignedToUnsigned(_ result: Int16) -> UInt16 {
    return UInt16(Int(UInt16.max) + Int(result) + 1)
}

func uintFromString(_ number: String, radix: Int = 10) throws -> UInt16 {
    if let result = UInt16(number, radix: radix) {
        return result
    }
    if let result = Int16(number, radix: radix) {
        return convertNegativeSignedToUnsigned(result)
    }
    throw UtilityErrors.NumberTooHighOrLow
}
