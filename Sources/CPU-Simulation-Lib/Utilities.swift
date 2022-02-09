//
//  Utilities.swift
//
//
//  Created by Paul on 28.01.22.
//

import Foundation

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
    "0x" + fillStringWithZeroes(string: toHexString(number), fillLength: 4)
}

public func toHexString(_ number: Int16) -> String {
    String(number, radix: 16).uppercased()
}

public func toLongHexString(_ number: Int16) -> String {
    getMinusIfNegative(number) + "0x" + getHexPositiveRepresentationOfNumberFilledWithZero(number)
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
    "0b" + toSeparatedBinString(number)
}

public func toBinString(_ number: Int16) -> String {
    String(number, radix: 2)
}

public func toSeparatedBinString(_ number: Int16) -> String {
    let normalString =  getBinPositiveRepresentationOfNumber(number)
    return getMinusIfNegative(number) + addWhitespacesToNumberString(normalString, charsInGroup: 4)
}

public func toLongBinString(_ number: Int16) -> String {
    getMinusIfNegative(number) + "0b" + getBinPositiveRepresentationOfNumberFilledWithZero(number)
}

public func toSeparatedLongBinString(_ number: Int16)->String {
    let normalString =  getBinPositiveRepresentationOfNumberFilledWithZero(number)
    return getMinusIfNegative(number) + "0b" + addWhitespacesToNumberString(normalString, charsInGroup: 4)
}
