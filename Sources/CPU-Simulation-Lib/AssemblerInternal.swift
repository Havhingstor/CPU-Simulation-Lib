//
//  AssemblerInternal.swift
//  
//
//  Created by Paul on 10.03.22.
//

import Foundation
import CPU_Simulation_Utilities

class AssemblerInternal {
    
    typealias Marker = AssemblingResults.Marker
    typealias OpcodeAddressValue = AssemblingResults.OpcodeAddressValue
    typealias LiteralAddressValue = AssemblingResults.LiteralAddressValue
    typealias AddressAddressValue = AssemblingResults.AddressAddressValue
    
    static func createAssemblingResults(parseResults oldResults: [ResultItem]) -> AssemblingResults {
        var markers: [Marker] = []
        
        var addressValueTypes: [UInt16: AddressValueType] = [:]
        
        var results = oldResults
        
        assignOperationAddresses(parseResults: &results)
        
        for memVal in results {
            createAssembleResultFromParseResult(memVal, &addressValueTypes, &markers)
        }
        
        
        
        return AssemblingResults(markers: markers, memoryValues: addressValueTypes)
    }
    
    static func applyParseResults(memory: Memory, parseResult input: [ResultItem]) throws {
        var rawValues: [UInt16] = []
        
        for value in input {
            rawValues.append(value.value)
            
            if let value = value as? Operation {
                rawValues.append(value.operand)
            }
        }
        
        try applyRawValues(memory: memory, values: rawValues)
    }
    
    static func parse(tokens: [Token]) throws -> [ResultItem] {
        var result = try parseTokens(tokens)
        
        
        let markers = try createMarkerAssignment(result)
        
        try resolveMarkers(&result, markers)
        
        return result
    }
    
    static func lex(_ assemblyCode: String) -> [Token] {
        var result: [Token] = []
        
        let lines = splitStringIntoLines(assemblyCode)
        
        lexLinesInString(lines, &result)
        
        return result
    }
    
    private static func splitStringIntoLines(_ input: String) -> [String.SubSequence] {
        return input.split(separator: "\n")
    }
    
    private static func itemIsComment(_ item: Substring.SubSequence) -> Bool {
        return item.first == "#"
    }
    
    private static func lexItemsInLine(_ items: [Substring.SubSequence], _ result: inout [Token]) {
        
        var hasAlreadyAOperator = false
        
        for item in items {
            if itemIsComment(item) {
                break
            }
            
            result.append(convertItemToToken(String(item), hasAlreadyAOperator: &hasAlreadyAOperator))
        }
    }
    
    private static func lexLinesInString(_ lines: [String.SubSequence], _ result: inout [Token]) {
        for line in lines {
            let items = splitLineIntoItems(line: line)
            
            lexItemsInLine(items, &result)
            
            result.append(Token(value: "", type: .newline))
        }
    }
    
    private static func tokenIsMarker(_ token: Token) -> Bool {
        return token.type == .marker
    }
    
    private static func appendTokenToMarkerStack(_ markerStack: inout [String], _ token: Token) {
        markerStack.append(token.value)
    }
    
    private static func tokenIsNewLine(_ token: Token) -> Bool {
        return token.type == .newline
    }
    
    private static func appendTokenToParseResult(_ token: Token, _ index: inout Int, _ tokens: [Token],
                                                 _ lineNr: Int, _ markerStack: inout [String], _ result: inout [ResultItem]) throws {
        let item = try parseToken(token: token, index: &index, tokenList: tokens, line: lineNr, markers: markerStack)
        
        markerStack.removeAll()
        
        result.append(item)
    }
    
    private static func handleToken(_ tokens: [Token], _ index: inout Int, _ markerStack: inout [String],
                                    _ lineNr: inout Int, _ result: inout [ResultItem]) throws {
        let token = tokens[index]
        
        if tokenIsMarker(token) {
            appendTokenToMarkerStack(&markerStack, token)
        } else if tokenIsNewLine(token) {
            lineNr += 1
        } else {
            try appendTokenToParseResult(token, &index, tokens, lineNr, &markerStack, &result)
        }
    }
    
    private static func parseTokens(_ tokens: [Token]) throws -> [ResultItem] {
        var result: [ResultItem] = []
        
        var markerStack: [String] = []
        
        var index = 0
        var lineNr = 1
        
        while index < tokens.count {
            try handleToken(tokens, &index, &markerStack, &lineNr, &result)
            index += 1
        }
        
        return result
    }
    
    private static func testForTooBigProgram(_ address: Int) throws {
        if address > 0xffff {
            throw AssemblerErrors.ProgramTooBigError
        }
    }
    
    private static func convertCountingAddressToRealAddress(countingAddress address: Int) -> UInt16 {
        return UInt16(address)
    }
    
    private static func testForDoubleMarker(marker: String ,markers: [String: UInt16], line: Int) throws {
        if markers[marker] != nil {
            throw AssemblerErrors.MarkerExistsTwiceError(marker: marker, line: line)
        }
    }
    
    private static func addMarkerToList(marker: String, address: UInt16, markerList markers: inout [String : UInt16]) {
        markers.updateValue(address, forKey: marker)
    }
    
    private static func handleAddressForOperation(_ value: ResultItem, _ address: inout Int) {
        if value as? TmpOperation != nil {
            address += 1
        }
    }
    
    private static func addMarkersToList(currentAddress address: Int, resultItem value: ResultItem,
                                         markerList markers: inout [String : UInt16]) throws {
        let realAddress = convertCountingAddressToRealAddress(countingAddress: address)
        
        for marker in value.markers {
            try testForDoubleMarker(marker: marker, markers: markers, line: value.line)
            
            addMarkerToList(marker: marker, address: realAddress, markerList: &markers)
        }
    }
    
    private static func createMarkerAssignment(_ result: [ResultItem]) throws -> [String : UInt16] {
        var markers: [String: UInt16] = [:]
        var address = 0
        
        for value in result {
            try testForTooBigProgram(address)
            
            try addMarkersToList(currentAddress: address, resultItem: value, markerList: &markers)
            
            handleAddressForOperation(value, &address)
            
            address += 1
        }
        
        return markers
    }
    
    private static func tryTransformResultItemToTmpOperation(_ oldValue: ResultItem) -> AssemblerInternal.TmpOperation? {
        return oldValue as? TmpOperation
    }
    
    private static func tryTransformTmpToFinalOperation(_ oldValue: AssemblerInternal.TmpOperation, _ markers: [String : UInt16]) -> AssemblerInternal.Operation? {
        return oldValue.convert(markerDictionary: markers)
    }
    
    private static func replaceTmpWithFinalOperation(_ result: inout [ResultItem], _ valueIndex: Int, _ newValue: AssemblerInternal.Operation) {
        result.remove(at: valueIndex)
        result.insert(newValue, at: valueIndex)
    }
    
    private static func throwErrorFoNonexistingMarker(_ oldValue: AssemblerInternal.TmpOperation) throws {
        throw AssemblerErrors.MarkerDoesntExistError(marker: oldValue.operand, line: oldValue.line)
    }
    
    private static func replaceResultItemIfPossible(_ oldValue: AssemblerInternal.TmpOperation, _ markers: [String : UInt16], _ result: inout [ResultItem], _ valueIndex: Int) throws {
        if let newValue = tryTransformTmpToFinalOperation(oldValue, markers) {
            replaceTmpWithFinalOperation(&result, valueIndex, newValue)
        } else {
            try throwErrorFoNonexistingMarker(oldValue)
        }
    }
    
    private static func replaceResultItemIfNecessary(_ markers: [String : UInt16], _ result: inout [ResultItem], _ valueIndex: Int) throws {
        let oldValue = result[valueIndex]
        
        if let oldValue = tryTransformResultItemToTmpOperation(oldValue) {
            try replaceResultItemIfPossible(oldValue, markers, &result, valueIndex)
        }
    }
    
    private static func resolveMarkers(_ result: inout [ResultItem], _ markers: [String : UInt16]) throws {
        for valueIndex in result.startIndex ..< result.endIndex {
            try replaceResultItemIfNecessary(markers, &result, valueIndex)
        }
    }
    
    private static func createAssembleResultOfOperation(_ memVal: AssemblerInternal.Operation, _ addressValueTypes: inout [UInt16 : AddressValueType], _ address: UInt16) {
        let `operator` = memVal.operator
        let operandType = memVal.operandType
        
        addressValueTypes.updateValue(OpcodeAddressValue(operator: `operator`, operandType: operandType), forKey: address)
        
        getAddressValuesForOperand(operandType, &addressValueTypes, address, valueInAddress: memVal.operand)
    }
    
    private static func getAddressValuesForOperand(_ operandType: AccessibleOperandType, _ addressValueTypes: inout [UInt16 : AddressValueType], _ address: UInt16, valueInAddress: UInt16) {
        if operandType.coreOperandType.providesAddressOrWriteAccess {
            addressValueTypes.updateValue(AddressAddressValue(value: valueInAddress), forKey: address &+ 1)
        } else {
            addressValueTypes.updateValue(LiteralAddressValue(value: valueInAddress), forKey: address &+ 1)
        }
    }
    
    private static func createAssembleResultOfVariable(_ addressValueTypes: inout [UInt16 : AddressValueType], _ address: UInt16, valueInAddress: UInt16) {
        addressValueTypes.updateValue(LiteralAddressValue(value: valueInAddress), forKey: address)
    }
    
    private static func createMarkersFromParseResult(_ memVal: ResultItem, _ markers: inout [AssemblingResults.Marker], _ address: UInt16, _ type: AssemblerInternal.Marker.`Type`) {
        for marker in memVal.markers {
            markers.append(Marker(name: marker, address: address, type: type))
        }
    }
    
    private static func createAssembleResultFromParseResult(_ memVal: ResultItem, _ addressValueTypes: inout [UInt16 : AddressValueType], _ markers: inout [AssemblingResults.Marker]) {
        let address = memVal.address!
        var type: Marker.`Type` = .undefined
        
        if let memVal = memVal as? Operation {
            type = .jumpMarker
            createAssembleResultOfOperation(memVal, &addressValueTypes, address)
        } else if let _ = memVal as? Variable {
            type = .variable
            createAssembleResultOfVariable(&addressValueTypes, address, valueInAddress: memVal.value)
        }
        
        createMarkersFromParseResult(memVal, &markers, address, type)
    }
    
    private static func assignOperationAddresses(parseResults results: inout [ResultItem]) {
        var address = UInt16(0)
        
        for i in 0 ..< results.count  {
            results[i].address = address
            
            let result = results[i]
            
            if let _ = result as? Operation {
                address &+= 1
            }
            
            address &+= 1
        }
    }
    
    private static func applyRawValues(memory: Memory, values: [UInt16]) throws {
        try memory.writeValues(values: values)
    }
    
    private static func handleUnallowedOperand(_ token: Token, _ line: Int) throws {
        if token.type == .operand {
            throw AssemblerErrors.OperandNotAllowedError(operand: token.value, line: line)
        }
    }
    
    private static func isOperatorWord(_ token: Token) -> Bool {
        return token.value.lowercased() == "word"
    }
    
    private static func parseWord(_ index: inout Int, _ list: [Token], _ line: Int, _ markers: [String]) throws -> ResultItem {
        index += 1
        let token = list[index]
        
        let value = readNumber(input: token.value)
        
        if token.type != .operand || value == nil {
            throw AssemblerErrors.OperandMissing(operator: token.value, line: line)
        }
        
        return Variable(line: line, markers: markers, value: value!)
    }
    
    private static func parseOperator(_ token: Token) -> Operator? {
        return StandardOperators.getOperatorNameAssignment()[token.value.lowercased()]?()
    }
    
    private static func testForAppendedI(_ tmpOperator: inout Operator?, _ token: Token) -> Bool {
        if tmpOperator == nil && token.value.last?.lowercased() == "i" {
            let newOperatorString = String(token.value.dropLast())
            
            let assignment = StandardOperators.getOperatorNameAssignment()
            tmpOperator = assignment[newOperatorString.lowercased()]?()
            
            return true
        }
        
        return false
    }
    
    private static func handleUndecodableOperator(_ tmpOperator: Operator?, _ token: Token, _ line: Int) throws {
        if tmpOperator == nil {
            throw AssemblerErrors.OperatorNotDecodableError(operator: token.value, line: line)
        }
    }
    
    private static func testForNoOperand(index: Int, list: [Token]) -> Bool {
        index >= list.count
    }
    
    private static func handleNoOperand(_ index: inout Int, _ operandType: inout AccessibleOperandType?) {
        index -= 1
        operandType = StandardOperandTypes.emptyType()
    }
    
    private static func tokenIsNewline(_ token: Token) -> Bool {
        return token.type == .newline
    }
    
    private static func tokenIsntOperand(_ token: Token) -> Bool {
        return token.type != .operand
    }
    
    private static func handleWrongTokenInsteadOfOperand(_ token: Token, _ line: Int) throws {
        throw AssemblerErrors.OperandNotDecodableError(operand: token.value, line: line)
    }
    
    private static func parseOperandTypeForExistingOperand(_ iAppended: Bool, _ operandType: inout AccessibleOperandType?, _ token: Token, _ operand: inout String, _ line: Int) throws {
        if iAppended {
            operandType = StandardOperandTypes.iAppendedType()
        } else {
            let operandTypeTmp = getOperandType(operand: token.value)
            
            guard operandTypeTmp != nil else {
                throw AssemblerErrors.OperandNotDecodableError(operand: operand, line: line)
            }
            
            operandType = operandTypeTmp!.0
            operand = operandTypeTmp!.1
        }
    }
    
    private static func parseOperandTypeIfPossible(_ token: Token, _ index: inout Int, _ operandType: inout AccessibleOperandType?, _ line: Int, _ iAppended: Bool, _ operand: inout String) throws {
        if tokenIsNewline(token) {
            index -= 1
            operandType = StandardOperandTypes.emptyType()
        } else if tokenIsntOperand(token) {
            try handleWrongTokenInsteadOfOperand(token, line)
        } else {
            try parseOperandTypeForExistingOperand(iAppended, &operandType, token, &operand, line)
        }
    }
    
    private static func parseForExistingOperand(token: inout Token, _ list: [Token], _ index: Int, _ operand: inout String) {
        token = list[index]
        
        operand = token.value
    }
    
    private static func parseOperandIfPossible(_ index: inout Int, _ list: [Token], _ operandType: inout AccessibleOperandType?,
                                                   _ token: inout AssemblerInternal.Token, _ operand: inout String, _ line: Int, _ iAppended: Bool) throws {
        if testForNoOperand(index: index, list: list) {
            handleNoOperand(&index, &operandType)
        } else {
            parseForExistingOperand(token: &token, list, index, &operand)
            
            try parseOperandTypeIfPossible(token, &index, &operandType, line, iAppended, &operand)
        }
    }
    
    private static func parseToken(token firstToken: Token, index: inout Int, tokenList list: [Token], line: Int, markers: [String]) throws -> ResultItem {
        var token = firstToken
        
        try handleUnallowedOperand(token, line)
        
        if isOperatorWord(token) {
            return try parseWord(&index, list, line, markers)
        }
        
        var tmpOperator = parseOperator(token)
        
        let iAppended = testForAppendedI(&tmpOperator, token)
        
        try handleUndecodableOperator(tmpOperator, token, line)
        
        let `operator` = tmpOperator!
        
        index += 1
        
        var operandType: AccessibleOperandType? = nil
        
        var operand = ""
        
        try parseOperandIfPossible(&index, list, &operandType, &token, &operand, line, iAppended)
        
        let realOperandValue = readNumber(input: operand)
        
        if let realOperandValue = realOperandValue {
            return TmpOperation(markers: markers, operator: `operator`, operandType: operandType!, operand: realOperandValue, line: line)
        } else {
            return TmpOperation(markers: markers, operator: `operator`, operandType: operandType!, operand: operand, line: line)
        }
        
    }
    
    private static func getOperandType(operand: String) -> (AccessibleOperandType, String)? {
        for operandTypeInit in StandardOperandTypes.operandTypes {
            let operandType = operandTypeInit()
            
            let reversedOperand = operand.reversed()
            let reversedEnd = operandType.additionAtEnd.reversed()
            
            if operand.starts(with: operandType.additionInFront) && reversedOperand.starts(with: reversedEnd) {
                let startOffset = operandType.additionInFront.count
                let startIndex = operand.index(operand.startIndex, offsetBy: startOffset)
                
                let endOffset = operandType.additionAtEnd.count
                let endIndex = operand.index(operand.endIndex, offsetBy: -endOffset)
                
                let realOperand = operand[startIndex ..< endIndex]
                
                if isValidOperand(input: String(realOperand)) {
                    return (operandType, String(realOperand))
                }
            }
        }
        
        return nil
    }
    
    private static func isValidOperand(input: String) -> Bool {
        var isFirstChar = false
        
        for char in input {
            let lettersAndDigits = char.isLetter || char.isNumber || char == "-"
            let acceptedSymbols = isFirstChar && ["_", "$"].contains(char)
            
            if !lettersAndDigits && !acceptedSymbols {
                return false
            }
            
            isFirstChar = true
        }
        
        return true
    }
    
    private static func readNumber(input: String) -> UInt16? {
        if input.starts(with: "0b") || input.starts(with: "-0b") {
            return try? binFromString(input)
        }
        if input.starts(with: "0x") || input.starts(with: "-0x") {
            return try? hexFromString(input)
        }
        return try? decFromString(input)
    }
    
    private static func convertItemToToken(_ item: String, hasAlreadyAOperator: inout Bool) -> Token {
        let token: Token!
        
        if item.last == ":" { // Marker
            let markerName = String(item.dropLast())
            
            token = Token(value: markerName, type: .marker)
        } else if !hasAlreadyAOperator { // Operator
            let `operator` = String(item)
            
            token = Token(value: `operator`, type: .operator)
            
            hasAlreadyAOperator = true
        } else { // operand
            let operand = String(item)
            
            token = Token(value: operand, type: .operand)
        }
        
        return token
    }
    
    private static func splitLineIntoItems(line: String.SubSequence) -> [Substring.SubSequence] {
        line.split() { char in
            char == " " || char == "\t"
        }
    }
    
    struct Operation: ResultItem {
        var address: UInt16?
        var line: Int
        
        var markers: [String]
        var value: UInt16 { UInt16(`operator`.operatorCode) | operandType.operandTypeCodePreparedForOpcode }
        
        var `operator`: Operator
        var operandType: AccessibleOperandType
        var operand: UInt16
    }
    
    
    class TmpOperation: ResultItem {
        var address: UInt16?
        
        var line: Int = 0
        var markers: [String]
        var value: UInt16 { UInt16(`operator`.operatorCode) | operandType.operandTypeCodePreparedForOpcode }
        
        var `operator`: Operator
        var operandType: AccessibleOperandType
        private var _operand: UInt16?
        private var _operandString: String?
        var operand: String {
            if let operand = _operand {
                return String(operand)
            }
            return _operandString!
        }
        
        func convert(markerDictionary dict: [String: UInt16]) -> Operation? {
            if let operandString = _operandString {
                _operand = dict[operandString]
                if _operand == nil {
                    if !operandType.coreOperandType.isNothing {
                        return nil
                    } else {
                        _operand = 0
                    }
                }
            }
            return Operation(line: line, markers: markers, operator: `operator`, operandType: operandType, operand: _operand!)
        }
        
        init(markers: [String], operator: Operator, operandType: AccessibleOperandType, operand: UInt16, line: Int) {
            self.markers = markers
            self.operator = `operator`
            self.operandType = operandType
            self._operand = operand
            self.line = line
        }
        
        init(markers: [String], operator: Operator, operandType: AccessibleOperandType, operand: String, line: Int) {
            self.markers = markers
            self.operator = `operator`
            self.operandType = operandType
            self._operandString = operand
            self.line = line
        }
        
    }
    
    struct Variable: ResultItem {
        
        var address: UInt16?
        
        var line: Int
        
        var markers: [String]
        
        var value: UInt16
    }
    
    struct Token {
        var value: String
        var type: `Type`
        
        enum `Type` {
            case marker
            case `operator`
            case operand
            case newline
        }
    }
}

protocol ResultItem {
    var markers: [String] { get }
    var value: UInt16 { get }
    var line: Int { get }
    var address: UInt16? { get set }
}
