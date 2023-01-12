//
//  ChartParameters.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/13/22.
//

import Foundation

class ChartParameters: Codable {
    enum State: String, Codable {
        case live
        case livePaused
        case timeboxed
        case unspecified
    }
    var state: State = .unspecified
    
    var liveInterval: TimeInterval = 25.0
    var start: Date = Date.now
    var end: Date = Date.now.addingTimeInterval(-25.0)
    
    var yMin: Float = 0.0
    var yMax: Float = 100.0
    
    var shouldAutoScale: Bool = false
    
    var yRange: ClosedRange<Float> {
        return yMin...yMax
    }
    
    var xRange: ClosedRange<Date> {
        switch state {
        case .live, .unspecified:
            return Date.now.addingTimeInterval(-liveInterval)...Date.now
        case .timeboxed, .livePaused:
            return start...end
        }
    }
}
