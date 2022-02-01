import XCTest
@testable import CPU_Simulation_Lib

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
