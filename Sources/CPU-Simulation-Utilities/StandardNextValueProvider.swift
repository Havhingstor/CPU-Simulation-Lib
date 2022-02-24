//
//  StandardProvider.swift
//  
//
//  Created by Paul on 23.02.22.
//

import Foundation

public class StandardNextValueProvider<T> {
    public typealias Builder = () -> T
    public let originalNextValue: Builder
    private var _standardNextValue: Builder?
    private var clientAssignment: [UUID: Builder?] = [:]
    
    public init(builder: @escaping Builder) {
        originalNextValue = builder
    }
    
    public func resetStandardNextValue() {
        _standardNextValue = nil
    }
    
    public var standardNextValue: Builder {
        get {
            if let standardNextValue = _standardNextValue {
                return standardNextValue
            }
            return originalNextValue
        }
        
        set(standardNextValue) {
            _standardNextValue = standardNextValue
        }
    }
    
    public func getNextValue(uuid: UUID) -> Builder {
        assureValueIsPresent(uuid: uuid)
        
        return clientAssignment[uuid]! ?? standardNextValue
    }
    
    public func setNextValue(builder: @escaping Builder, uuid: UUID) {
        clientAssignment.updateValue(builder, forKey: uuid)
    }
    
    public func resetNextValue(uuid: UUID) {
        clientAssignment.updateValue(nil, forKey: uuid)
    }
    
    private func assureValueIsPresent(uuid: UUID) {
        if testIfValueIsPresent(uuid: uuid) {
            createValue(uuid: uuid)
        }
    }
    
    private func testIfValueIsPresent(uuid: UUID) -> Bool {
        clientAssignment[uuid] == nil
    }
    
    private func createValue(uuid: UUID) {
        clientAssignment.updateValue(nil, forKey: uuid)
    }
}
