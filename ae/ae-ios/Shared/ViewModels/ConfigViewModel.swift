//
//  File.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/15/22.
//

import Foundation
import Combine
import aeble

@MainActor class ConfigViewModel: ObservableObject {
    
    let config: AEDataStreamConfig
    
    @Published var selectedValue: String
    @Published var selectedRangeValue: Double
    
    @Published var is_updated: Bool
    
    init(config: AEDataStreamConfig) {
        self.config = config
        
        self.selectedValue = config.defaultValue
        
        if self.config.range != nil {
            self.selectedRangeValue = Double(config.defaultValue)!
        } else {
            self.selectedRangeValue = 0.0
        }
        
        is_updated = false
    }
    
    func update(with value: String) {
        self.is_updated = true
        self.selectedValue = value
        
        if self.config.range != nil {
            self.selectedRangeValue = Double(selectedValue)!
        } else {
            self.selectedRangeValue = 0.0
        }
    }
}
