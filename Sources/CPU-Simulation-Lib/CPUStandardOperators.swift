//
//  CPUStandardOperators.swift
//  
//
//  Created by Paul on 12.02.22.
//

import Foundation

open class LOADOperator: Operator {open class var stringRepresentation: String {"LOAD"}
    open class var operatorCode: UInt8 {0x14}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class STOREOperator: Operator {
    open class var stringRepresentation: String {"STORE"}
    open class var operatorCode: UInt8 {0x15}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { true }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class ADDOperator: Operator {
    open class var stringRepresentation: String {"ADD"}
    open class var operatorCode: UInt8 {0xA}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class SUBOperator: Operator {
    open class var stringRepresentation: String {"SUB"}
    open class var operatorCode: UInt8 {0xB}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class MULOperator: Operator {
    open class var stringRepresentation: String {"MUL"}
    open class var operatorCode: UInt8 {0xC}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class DIVOperator: Operator {
    open class var stringRepresentation: String {"DIV"}
    open class var operatorCode: UInt8 {0xD}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class MODOperator: Operator {
    open class var stringRepresentation: String {"MOD"}
    open class var operatorCode: UInt8 {0xE}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class CMPOperator: Operator {
    open class var stringRepresentation: String {"CMP"}
    open class var operatorCode: UInt8 {0xF}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class ANDOperator: Operator {
    open class var stringRepresentation: String {"AND"}
    open class var operatorCode: UInt8 {0x28}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class OROperator: Operator {
    open class var stringRepresentation: String {"OR"}
    open class var operatorCode: UInt8 {0x29}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class XOROperator: Operator {
    open class var stringRepresentation: String {"XOR"}
    open class var operatorCode: UInt8 {0x2A}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class SHLOperator: Operator {
    open class var stringRepresentation: String {"SHL"}
    open class var operatorCode: UInt8 {0x2B}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class SHROperator: Operator {
    open class var stringRepresentation: String {"SHR"}
    open class var operatorCode: UInt8 {0x2C}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class SHRAOperator: Operator {
    open class var stringRepresentation: String {"SHRA"}
    open class var operatorCode: UInt8 {0x2D}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JMPPOperator: Operator {
    open class var stringRepresentation: String {"JMPP"}
    open class var operatorCode: UInt8 {0x1E}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { true }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JMPNNOperator: Operator {
    open class var stringRepresentation: String {"JMPNN"}
    open class var operatorCode: UInt8 {0x1F}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { true }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JMPNOperator: Operator {
    open class var stringRepresentation: String {"JMPN"}
    open class var operatorCode: UInt8 {0x20}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { true }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JMPNPOperator: Operator {
    open class var stringRepresentation: String {"JMPNP"}
    open class var operatorCode: UInt8 {0x21}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { true }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JMPZOperator: Operator {
    open class var stringRepresentation: String {"JMPZ"}
    open class var operatorCode: UInt8 {0x22}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { true }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JMPNZOperator: Operator {
    open class var stringRepresentation: String {"JMPNZ"}
    open class var operatorCode: UInt8 {0x23}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { true }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JMPVOperator: Operator {
    open class var stringRepresentation: String {"JMPV"}
    open class var operatorCode: UInt8 {0x25}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { true }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JMPOperator: Operator {
    open class var stringRepresentation: String {"JMP"}
    open class var operatorCode: UInt8 {0x24}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { true }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class JSROperator: Operator {
    open class var stringRepresentation: String {"JSR"}
    open class var operatorCode: UInt8 {0x5}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { true }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class RSVOperator: Operator {
    open class var stringRepresentation: String {"RSV"}
    open class var operatorCode: UInt8 {0x7}
    
    public class var requiresLiteralReadAccess: Bool { true }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class RELOperator: Operator {
    open class var stringRepresentation: String {"REL"}
    open class var operatorCode: UInt8 {0x8}
    
    public class var requiresLiteralReadAccess: Bool { true }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { false }
    
    public required init() {}
}

public class NOOPOperator: Operator {
    open class var stringRepresentation: String {"NOOP"}
    open class var operatorCode: UInt8 {0x0}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class HOLDOperator: Operator {
    open class var stringRepresentation: String {"HOLD"}
    open class var operatorCode: UInt8 {0x63}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class RESETOperator: Operator {
    open class var stringRepresentation: String {"RESET"}
    open class var operatorCode: UInt8 {0x1}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class NOTOperator: Operator {
    open class var stringRepresentation: String {"NOT"}
    open class var operatorCode: UInt8 {0x2E}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class RTSOperator: Operator {
    open class var stringRepresentation: String {"RTS"}
    open class var operatorCode: UInt8 {0x6}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class PUSHOperator: Operator {
    open class var stringRepresentation: String {"PUSH"}
    open class var operatorCode: UInt8 {0x19}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

public class POPOperator: Operator {
    open class var stringRepresentation: String {"POP"}
    open class var operatorCode: UInt8 {0x1A}
    
    public class var requiresLiteralReadAccess: Bool { false }
    public class var requiresAddressOrWriteAccess: Bool { false }
    public class var dontAllowOperandIfPossible: Bool { true }
    
    public required init() {}
}

extension CPUStandardVars {
    public static var standardOperators: [OperatorInit] { [
        LOADOperator.init,
        STOREOperator.init,
        ADDOperator.init,
        SUBOperator.init,
        MULOperator.init,
        DIVOperator.init,
        MODOperator.init,
        CMPOperator.init,
        ANDOperator.init,
        OROperator.init,
        XOROperator.init,
        SHLOperator.init,
        SHROperator.init,
        SHRAOperator.init,
        JMPPOperator.init,
        JMPNNOperator.init,
        JMPNOperator.init,
        JMPNPOperator.init,
        JMPZOperator.init,
        JMPNZOperator.init,
        JMPVOperator.init,
        JMPOperator.init,
        JSROperator.init,
        RSVOperator.init,
        RELOperator.init,
        NOOPOperator.init,
        HOLDOperator.init,
        RESETOperator.init,
        NOTOperator.init,
        RTSOperator.init,
        PUSHOperator.init,
        POPOperator.init,
    ] }
}
