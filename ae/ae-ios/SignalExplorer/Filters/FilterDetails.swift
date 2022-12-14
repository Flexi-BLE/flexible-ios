//
//  FilterDetails.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import Foundation
import flexiBLE_signal

class FilterDetails {
    var id: UUID
    var selection: any SignalFilter
    var isEnabled: Bool
    
    var src: Int?=nil
    var dest: Int?=nil
    
    init(selection: any SignalFilter, isEnabled: Bool = true, src: Int? = nil, dest: Int? = nil) {
        self.id = UUID()
        self.selection = selection
        self.isEnabled = isEnabled
        self.src = src
        self.dest = dest
    }
}
