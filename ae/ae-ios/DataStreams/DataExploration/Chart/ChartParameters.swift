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
    
    var dataYMin: Double = 0.0
    var dataYMax: Double = 100.0
    
    var yMin: Double = 0.0
    var yMax: Double = 100.0
    
    var yRange: ClosedRange<Double> {
        return yMin...yMax
    }
    
    var adjustableYMax: Double {
        return round(dataYMax + ((dataYMax - dataYMin) * 0.5))
    }
    
    var adjustableYMin: Double {
        return round(dataYMin - ((dataYMax - dataYMin)  * 0.5))
    }
    
    var adjustableYRange: ClosedRange<Double> {
        return adjustableYMin...adjustableYMax
    }
    
    var xRange: ClosedRange<Date> {
        switch state {
        case .live, .unspecified: return Date.now.addingTimeInterval(-liveInterval)...Date.now
        case .timeboxed, .livePaused: return start...end
        }
    }
}
