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
