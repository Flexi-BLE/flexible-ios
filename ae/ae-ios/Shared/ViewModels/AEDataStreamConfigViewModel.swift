//
//  File.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/15/22.
//

import Foundation
import Combine
import aeble

@MainActor class AEDataStreamConfigViewModel: ObservableObject {
    let config: AEDataStreamConfig
    
    // FIXME: placeholder value
    @Published var selectedValue: String
    @Published var selectedRangeValue: Double
    
    init(config: AEDataStreamConfig) {
        self.config = config
        
        
        // FIXME: should be read from BLE is connected
        self.selectedValue = config.defaultValue
        if self.config.range != nil {
            self.selectedRangeValue = Double(config.defaultValue)!
        } else {
            self.selectedRangeValue = 0.0
        }
    }
}
