//
//  InternalCPUVars.swift
//  
//
//  Created by Paul on 10.02.22.
//

import Foundation

class InternalCPUVars {
    var stackpointer: UInt16 = 0xfffe
    var accumulator: UInt16 = 0
    var dataBus: UInt16 = 0
    var addressBus: UInt16 = 0
    var lastMemoryInteraction: UInt16 = 0
    
    func applyNewCPUVars(vars: NewCPUVars) {
        applyStackpointer(vars.stackpointer)
        applyAccumulator(vars.accumulator)
        applyDataBus(vars.dataBus)
        applyAddressBus(vars.addressBus)
        applyLastMemoryInteraction(vars.lastMemoryInteraction)
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
        }
    }
    
    private func applyAddressBus(_ newAddressBus: UInt16?) {
        if let newAddressBus = newAddressBus {
            addressBus = newAddressBus
        }
    }
    
    private func applyLastMemoryInteraction(_ newLastMemoryInteraction: UInt16?) {
        if let newLastMemoryInteraction = newLastMemoryInteraction {
            lastMemoryInteraction = newLastMemoryInteraction
        }
    }
}
