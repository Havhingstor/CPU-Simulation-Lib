//
//  InternalCPUVars.swift
//  
//
//  Created by Paul on 10.02.22.
//

import Foundation
import CPU_Simulation_Utilities

class InternalCPUVars {
    var stackpointer: UInt16 = 0xfffe
    var accumulator: UInt16 = 0
    var dataBus: UInt16?
    var addressBus: UInt16?
    var lastMemoryInteraction: UInt16 = 0
    var nFlag = false
    var _zFlag: Bool?
    var vFlag = false
    
    var zFlag: Bool { _zFlag ?? false }
    
    func applyNewCPUVars(vars: NewCPUVars) {
        applyStackpointer(vars.stackpointer)
        applyAccumulator(vars.accumulator)
        applyDataBus(vars.dataBus)
        applyAddressBus(vars.addressBus)
        applyLastMemoryInteraction(vars.lastMemoryInteraction)
        applyVFlag(vars.vFlag)
        applyZFlag(accumulator: accumulator)
        applyNFlag(accumulator: accumulator)
    }
    
    private func applyVFlag(_ newVFlag: Bool?) {
        if let newVFlag = newVFlag {
            vFlag = newVFlag
        }
    }
    
    private func applyZFlag(accumulator: UInt16) {
        if accumulator != 0 {
            _zFlag = false
        }else if _zFlag != nil {
            _zFlag = true
        }
    }
    
    private func applyNFlag(accumulator: UInt16) {
        if unsignedToSigned(accumulator) < 0 {
            nFlag = true
        }
    }
    
    private func applyStackpointer(_ newStackpointer: UInt16?) {
        if let newStackpointer = newStackpointer {
            stackpointer = newStackpointer
        }
    }
    
    private func applyAccumulator(_ newAccumulator: UInt16?) {
        if let newAccumulator = newAccumulator {
            accumulator = newAccumulator
        }
    }
    
    private func applyDataBus(_ newDataBus: UInt16?) {
        if let newDataBus = newDataBus {
            dataBus = newDataBus
        } else {
            dataBus = nil
        }
    }
    
    private func applyAddressBus(_ newAddressBus: UInt16?) {
        if let newAddressBus = newAddressBus {
            addressBus = newAddressBus
        } else {
            addressBus = nil
        }
    }
    
    private func applyLastMemoryInteraction(_ newLastMemoryInteraction: UInt16?) {
        if let newLastMemoryInteraction = newLastMemoryInteraction {
            lastMemoryInteraction = newLastMemoryInteraction
        }
    }
}
