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
    var nFlag = false
    var zFlag = false
    var vFlag = false
    
    func applyNewCPUVars(vars: NewCPUVars) {
        applyStackpointer(vars.stackpointer)
        applyAccumulator(vars.accumulator)
        applyDataBus(vars.dataBus)
        applyAddressBus(vars.addressBus)
        applyVFlag(vars.vFlag)
        applyZFlag(vars.zFlag, newAccumulator: vars.accumulator)
        applyNFlag(vars.nFlag, newAccumulator: vars.accumulator)
    }
    
    private func applyVFlag(_ newVFlag: Bool?) {
        if let newVFlag = newVFlag {
            vFlag = newVFlag
        }
    }
    
    private func applyZFlag(_ newZFlag: Bool?, newAccumulator: UInt16?) {
        if let newZFlag = newZFlag {
            zFlag = newZFlag
        } else {
            applyZFlagFromAccumulator(newAccumulator)
        }
    }
    
    private func applyZFlagFromAccumulator(_ newAccumulator: UInt16?) {
        if let newAccumulator = newAccumulator {
            zFlag = newAccumulator == 0
        }
    }
    
    private func applyNFlag(_ newNFlag: Bool?, newAccumulator: UInt16?) {
        if let newNFlag = newNFlag {
            nFlag = newNFlag
        } else {
            applyNFlagFromAccumulator(newAccumulator)
        }
    }
    
    private func applyNFlagFromAccumulator(_ newAccumulator: UInt16?) {
        if let newAccumulator = newAccumulator {
            nFlag = unsignedToSigned(newAccumulator) < 0
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
}
