//
//  File.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/15/22.
//

import Foundation
import Combine
import FlexiBLE

@MainActor class ConfigViewModel: ObservableObject {
    
    let config: FXBDataStreamConfig
    
    @Published var selectedValue: String
    @Published var selectedRangeValue: Double {
        didSet {
            selectedValue = String(selectedRangeValue)
        }
    }
    
    @Published var is_updated: Bool
    
    var multiSelectIndicies: [Int] {
        guard config.selectionType == .bitEncodedMultiSelect,
              let val = UInt(selectedValue),
              let options = config.options else { return [] }
        
        return options.enumerated().compactMap({ i, option -> Int? in
            if let optionVal = UInt(option.value) {
                if ((val & optionVal) > 0) {
                    return i
                }
            }
            return nil
        })
    }
    
    var multiSelectSelections: [String] {
        guard let options = config.options else { return [] }
        return multiSelectIndicies.map({ options[optional: $0]?.name ?? "--unknown--" })
    }
    
    func selectOption(named: String) {
        guard let selection = config.options?.first(where: { named == $0.name }) else { return }
        self.selectedValue = String((UInt(selectedValue) ?? 0) ^ (UInt(selection.value) ?? 0))
    }
    
    func deselectOption(named: String) {
        guard let selection = config.options?.first(where: { named == $0.name }) else { return }
        self.selectedValue = String((UInt(selectedValue) ?? 0) ^ (UInt(selection.value) ?? 0))
    }
    
    init(config: FXBDataStreamConfig) {
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
        }
    }
}
