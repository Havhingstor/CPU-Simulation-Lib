//
//  Utilities.swift
//
//
//  Created by Paul on 28.01.22.
//

import Foundation

private let decimalCharSet = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-"]
private let binaryCharSet = ["0", "1", "-"]
private let hexadecimalCharSet = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "-"]

public func decFromString(_ number: String) throws -> UInt16 {
    try guaranteeDecimalNumber(number)
    return try uintFromString(number)
}

public func hexFromString(_ number: String) throws -> UInt16 {
    let cleanedNum = removePrefixOfString(number, prefix: "0x")
    try guaranteeHexadecimalNumber(cleanedNum)
    return try uintFromString(cleanedNum, radix: 16)
}

public func binFromString(_ number: String) throws -> UInt16 {
    let cleanedNum = removePrefixOfString(number, prefix: "0b")
    try guaranteeBinaryNumber(cleanedNum)
    return try uintFromString(cleanedNum, radix: 2)
}

public func signedToUnsigned(_ number: Int16) -> UInt16 {
    UInt16(bitPattern: number)
}

public func unsignedToSigned(_ number: UInt16) -> Int16 {
    return Int16(bitPattern: number)
}

public func toDecString(_ number: UInt16) -> String {
    String(number)
}

public func toDecString(_ number: Int16) -> String {
    String(number)
}

public func toHexString(_ number: UInt16) -> String {
    String(number, radix: 16).uppercased()
}

public func toLongHexString(_ number: UInt16) -> String {
    "0x" + toHexString(number)
}

public func toHexString(_ number: Int16) -> String {
    String(number, radix: 16).uppercased()
}

public func toLongHexString(_ number: Int16) -> String {
    getMinusIfNegative(number) + "0x" + getHexPositiveRepresentationOfNumber(number)
}

public func toBinString(_ number: UInt16) -> String {
    String(number, radix: 2)
}

public func toSeparatedBinString(_ number: UInt16) -> String {
    let normalString = toBinString(number)
    return addWhitespacesToNumberString(normalString, charsInGroup: 4)
}

public func toLongBinString(_ number: UInt16) -> String {
    "0b" + toBinString(number)
}

public func toSeparatedLongBinString(_ number: UInt16)->String {
    "0b " + toSeparatedBinString(number)
}

public func toBinString(_ number: Int16) -> String {
    String(number, radix: 2)
}

public func toSeparatedBinString(_ number: Int16) -> String {
    let normalString =  getBinPositiveRepresentationOfNumber(number)
    return getMinusIfNegative(number) + " " + addWhitespacesToNumberString(normalString, charsInGroup: 4)
}

public func toLongBinString(_ number: Int16) -> String {
    getMinusIfNegative(number) + "0b" + getBinPositiveRepresentationOfNumber(number)
}

public func toSeparatedLongBinString(_ number: Int16)->String {
    let normalString =  getBinPositiveRepresentationOfNumber(number)
    return getMinusIfNegative(number) + "0b " + addWhitespacesToNumberString(normalString, charsInGroup: 4)
}

private func addWhitespacesToNumberString(_ numberString: String, charsInGroup: Int) -> String {
    var result = ""

    for i in getReverseStringIndexes(numberString) {
        updateStringWithChar(&result, origin: numberString, index: i, charsInGroup: charsInGroup)
    }

    return removeWhitespacesAtStartAndEnd(result)
}

private func removeWhitespacesAtStartAndEnd(_ string: String) -> String {
    string.trimmingCharacters(in: .whitespaces)
}

private func updateStringWithChar(_ string: inout String, origin: String, index i: Int, charsInGroup: Int) {
    string = getReverseCharOfString(origin, index: i) + string
    string = addWhitespaceIfGroupHasEnded(string, index: i, charsInGroup: charsInGroup)
}

private func addWhitespaceIfGroupHasEnded(_ string: String, index i: Int, charsInGroup: Int) -> String {
    if dividableThrough(i, charsInGroup) {
        return " " + string
    }
    return string
}

private func dividableThrough(_ i: Int, _ charsInGroup: Int) -> Bool {
    return i % charsInGroup == 0
}

private func getReverseCharOfString(_ string: String, index i: Int) -> String {
    let offset = string.count - i
    return String(string[String.Index(utf16Offset: offset, in: string)])
}

private func getReverseStringIndexes(_ string: String) -> ClosedRange<Int> {
    1 ... string.count
}

private func getHexPositiveRepresentationOfNumber(_ number: Int16) -> String {
    let positiveNumber = abs(number)
    return toHexString(positiveNumber)
}

private func getBinPositiveRepresentationOfNumber(_ number: Int16) -> String {
    let positiveNumber = abs(number)
    return toBinString(positiveNumber)
}

private func getMinusIfNegative(_ number: Int16) -> String {
    number < 0 ? "-" : ""
}

private func lowercasedCharIsInCharset(_ charSet: [String], _ character: String.Element) -> Bool {
    return charSet.contains(String(character).lowercased())
}

private func goThroughCharsAndTestIfInCharset(_ number: String, charSet: [String]) -> Bool {
    var allowed = true
    for character in number {
        if !lowercasedCharIsInCharset(charSet, character) {
            allowed = false
        }
    }
    return allowed
}

private func guaranteeNumberInCharSet(_ number: String, charSet: [String]) throws {
    if !goThroughCharsAndTestIfInCharset(number, charSet: charSet) {
        throw UtilityErrors.NoNumber
    }
}

private func guaranteeDecimalNumber(_ number: String) throws {
    try guaranteeNumberInCharSet(number, charSet: decimalCharSet)
}

private func guaranteeHexadecimalNumber(_ number: String) throws {
    try guaranteeNumberInCharSet(number, charSet: hexadecimalCharSet)
}

private func guaranteeBinaryNumber(_ number: String) throws {
    try guaranteeNumberInCharSet(number, charSet: binaryCharSet)
}

private func removePrefixOfString(_ val: String, prefix: String) -> String {
    var cleanedString = val

    cleanedString = removePrefixOfStringWithoutDealingWithMinus(cleanedString, prefix: prefix)
    cleanedString = removePrefixOfStringAfterMinusIfNeeded(cleanedString, prefix: prefix)

    return cleanedString
}

private func removePrefixOfStringWithoutDealingWithMinus(_ val: String, prefix: String) -> String {
    var cleanedStr = val

    if val.starts(with: prefix) {
        cleanedStr = removeFirstNChars(val, n: prefix.count)
    }

    return cleanedStr
}

private func removePrefixOfStringAfterMinusIfNeeded(_ val: String, prefix: String) -> String {
    var cleanedStr = val

    if val.starts(with: "-" + prefix) {
        cleanedStr = replacePrefixAfterMinus(val, prefix: prefix)
    }

    return cleanedStr
}

private func replacePrefixAfterMinus(_ val: String, prefix: String) -> String {
    let numberOfCharsToRemove = prefix.count + 1
    let strWithoutMinus = removeFirstNChars(val, n: numberOfCharsToRemove)
    let strWithMinus = "-" + strWithoutMinus
    return strWithMinus
}

private func removeFirstNChars(_ val: String, n: Int) -> String {
    var result = val

    for _ in 0 ..< n {
        result = String(result.dropFirst())
    }

    return result
}

private func convertNegativeSignedToUnsigned(_ result: Int16) -> UInt16 {
    return UInt16(Int(UInt16.max) + Int(result) + 1)
}

private func uintFromString(_ number: String, radix: Int = 10) throws -> UInt16 {
    if let result = UInt16(number, radix: radix) {
        return result
    }
    if let result = Int16(number, radix: radix) {
        return convertNegativeSignedToUnsigned(result)
    }
    throw UtilityErrors.NumberTooHighOrLow
}

enum UtilityErrors: Error {
    case NumberTooHighOrLow
    case NoNumber
}
