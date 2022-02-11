//
//  CPUStandardVars.swift
//  
//
//  Created by Paul on 11.02.22.
//

import Foundation

public class CPUStandardVars {
    public static var startingState: StateBuilder = originalStartingState
    public static var originalStartingState: StateBuilder = StateBuilder(HoldState.init)
    
    public static func resetStartingState() {
        startingState = originalStartingState
    }
}
