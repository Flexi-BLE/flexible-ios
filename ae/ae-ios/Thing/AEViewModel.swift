//
//  AEViewModel.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import Foundation
import Combine
import aeble

class AEViewModel: ObservableObject {
    let config: AEDeviceConfig
    
    init(_ config: AEDeviceConfig) {
        self.config = config
    }
}
