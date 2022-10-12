//
//  DataStreamGraphParameters.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/4/22.
//

import Foundation

class DataStreamGraphParameters: Codable {
    enum State: String, Codable {
        case live
        case livePaused
        case timeboxed
        case unspecified
    }
    
    var state: State = .unspecified
    
    var filterSelections: [String:[Int]] = [:]
    
    var dependentSelections: [String] = []
    
    var liveInterval: TimeInterval = 25.0
    var start: Date = Date.now
    var end: Date = Date.now.addingTimeInterval(-25.0)
}
