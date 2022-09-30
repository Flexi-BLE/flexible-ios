//
//  aeble.swift
//  ae
//
//  Created by blaine on 4/13/22.
//

import Foundation
import UIKit
import aeble

var aeble: AEBLE = {
    do {
        let aeble = try AEBLE()
        aeble.settings.deviceId = UIDevice.current.id
        
        return aeble
    } catch {
        fatalError("Canot initialize aeble")
    }
}()
