import XCTest
@testable import CPU_Simulation_Utilities

final class StringToNumbersTester: XCTestCase {

    func testConvertDecimalStringToUInt16() {
        var num = "1234"
        XCTAssertEqual(try decFromString(num), UInt16(1234))

        num = "1"
        XCTAssertEqual(try decFromString(num), UInt16(1))
    }

    func testDecimalConverterTooHighOrTooLow() {
        var num = "100000"

        XCTAssertThrowsError(try decFromString(num)) { err in
            XCTAssertEqual(err as? UtilityErrors, UtilityErrors.NumberTooHighOrLow)
        }

        num = "-33000"

        XCTAssertThrowsError(try decFromString(num)) { err in
            XCTAssertEqual(err as? UtilityErrors, UtilityErrors.NumberTooHighOrLow)
        }
    }

    func testDecimalConverterNoNumber() {
        let noNum = "NoNum"

        XCTAssertThrowsError(try decFromString(noNum)) { err in
            XCTAssertEqual(err as? UtilityErrors, UtilityErrors.NoNumber)
        }
    }

    func testDecimalConverterNegative() {
        let num = "-2"

        XCTAssertEqual(try decFromString(num), 0xfffe)
    }

    func testConvertHexadecimalStringToUInt16() {
        var num = "10"
        XCTAssertEqual(try hexFromString(num), UInt16(16))

        num = "120"
        XCTAssertEqual(try hexFromString(num), UInt16(288))
    }

    func testHexadecimalConverterTooHighOrTooLow() {
        var num = "10000"

        XCTAssertThrowsError(try hexFromString(num)) { err in
            XCTAssertEqual(err as? UtilityErrors, UtilityErrors.NumberTooHighOrLow)
        }

        num = "-8001"

        XCTAssertThrowsError(try hexFromString(num)) { err in
            XCTAssertEqual(err as? UtilityErrors, UtilityErrors.NumberTooHighOrLow)
        }
    }

    func testHexadecimalConverterNoNumber() {
        let noNum = "NoNum"

        XCTAssertThrowsError(try hexFromString(noNum)) { err in
            XCTAssertEqual(err as? UtilityErrors, UtilityErrors.NoNumber)
        }

        XCTAssertNoThrow(try hexFromString("ffFf"))
    }

    func testHexadecimalConverterNegative() {
        let num = "-30"

        XCTAssertEqual(try hexFromString(num), 0xFFD0)
    }

    func testHexadecimalConverterWith0x() {
        var num = "0x100"

        XCTAssertEqual(try hexFromString(num), 0x100)

        num = "-0x100"

        XCTAssertEqual(try hexFromString(num), 0xFF00)
    }

    func testConvertBinaryStringToUInt16() {
        var num = "10000"
        XCTAssertEqual(try binFromString(num), UInt16(16))

        num = "101100000"
        XCTAssertEqual(try binFromString(num), UInt16(352))
    }

    func testBinaryConverterTooHighOrTooLow() {
        var num = "10000000000000000"

        XCTAssertThrowsError(try hexFromString(num)) { err in
            XCTAssertEqual(err as? UtilityErrors, UtilityErrors.NumberTooHighOrLow)
        }

        num = "-1000000000000001"

        XCTAssertThrowsError(try hexFromString(num)) { err in
            XCTAssertEqual(err as? UtilityErrors, UtilityErrors.NumberTooHighOrLow)
        }
    }

    func testBinaryConverterNoNumber() {
        let noNum = "NoNum"

        XCTAssertThrowsError(try binFromString(noNum)) { err in
            XCTAssertEqual(err as? UtilityErrors, UtilityErrors.NoNumber)
        }

        XCTAssertThrowsError(try binFromString("123")) { err in
            XCTAssertEqual(err as? UtilityErrors, UtilityErrors.NoNumber)
        }
    }

    func testBinaryConverterNegative() {
        let num = "-10101"

        XCTAssertEqual(try binFromString(num), 0xffEB)
    }

    func testBinaryConverterWith0b() {
        var num = "0b100"

        XCTAssertEqual(try binFromString(num), 0b100)

        num = "-0b100"

        XCTAssertEqual(try binFromString(num), try binFromString("-100"))
    }

}

final class NumberToNumberTester: XCTestCase {

    func testSignedToUnsigned() {
        var signed = Int16(15)
        XCTAssertEqual(signedToUnsigned(signed), UInt16(15))

        signed = 25
        XCTAssertEqual(signedToUnsigned(signed), UInt16(25))
    }

    func testNegativeSignedToUnsigned() {
        let signed = Int16(-1)
        XCTAssertEqual(signedToUnsigned(signed), UInt16(0xffff))
    }

    func testUnsignedToSigned() {
        var unsigned = UInt16(0x1234)
        XCTAssertEqual(unsignedToSigned(unsigned), 0x1234)

        unsigned = 0x5678
        XCTAssertEqual(unsignedToSigned(unsigned), 0x5678)
    }

    func testHighUnsignedToSigned() {
        let unsigned = UInt16(0xabcd)
        XCTAssertEqual(unsignedToSigned(unsigned), -0x5433)
    }
}

final class NumberToStringTester: XCTestCase {

    func testUIntToDec() {
        var num = UInt16(100)
        XCTAssertEqual(toDecString(num), "100")

        num = UInt16(56789)
        XCTAssertEqual(toDecString(num), "56789")
    }

    func testIntToDec() {
        var num = Int16(200)
        XCTAssertEqual(toDecString(num), "200")

        num = Int16(-100)
        XCTAssertEqual(toDecString(num), "-100")
    }

    func testUIntToHex() {
        var num = UInt16(0x100)
        XCTAssertEqual(toHexString(num), "100")
        XCTAssertEqual(toLongHexString(num), "0x0100")

        num = 0xabcd
        XCTAssertEqual(toHexString(num), "ABCD")
        XCTAssertEqual(toLongHexString(num), "0xABCD")
    }

    func testIntToHex() {
        var num = Int16(0x100)
        XCTAssertEqual(toHexString(num), "100")
        XCTAssertEqual(toLongHexString(num), "0x0100")

        num = -0xabc
        XCTAssertEqual(toHexString(num), "-ABC")
        XCTAssertEqual(toLongHexString(num), "-0x0ABC")
    }
    
    func testUIntToBinary() {
        var num = UInt16(0b1010010101010100)
        XCTAssertEqual(toBinString(num), "1010010101010100")
        XCTAssertEqual(toLongBinString(num), "0b1010010101010100")
        
        num = 0b1010_1011_1100_1101
        XCTAssertEqual(toBinString(num), "1010101111001101")
        XCTAssertEqual(toLongBinString(num), "0b1010101111001101")
        XCTAssertEqual(toSeparatedBinString(num), "1010 1011 1100 1101")
        XCTAssertEqual(toSeparatedLongBinString(num), "0b1010 1011 1100 1101")
    }
    
    func testIntToBinary() {
        var num = Int16(0b0110_0101_0101_0100)
        XCTAssertEqual(toBinString(num), "110010101010100")
        XCTAssertEqual(toLongBinString(num), "0b0110010101010100")
        XCTAssertEqual(toSeparatedBinString(num), "110 0101 0101 0100")
        XCTAssertEqual(toSeparatedLongBinString(num), "0b0110 0101 0101 0100")
        
        num = -0b111_0101_1010_1011
        XCTAssertEqual(toBinString(num), "-111010110101011")
        XCTAssertEqual(toLongBinString(num), "-0b0111010110101011")
        XCTAssertEqual(toSeparatedBinString(num), "-111 0101 1010 1011")
        XCTAssertEqual(toSeparatedLongBinString(num), "-0b0111 0101 1010 1011")
    }
}
