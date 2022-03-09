//
//  Utilities.swift
//  
//
//  Created by Paul on 12.02.22.
//

import Foundation
import CPU_Simulation_Lib

class OwnDecode: DecodedState {
    override func operate(cpu: CPUCopy) -> NewCPUVars {
        NewCPUVars()
    }
}

class OwnExecution: ExecutedState {
    override func operate(cpu: CPUCopy) -> NewCPUVars {
        NewCPUVars()
    }
}
