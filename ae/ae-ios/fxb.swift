//
//  aeble.swift
//  ae
//
//  Created by blaine on 4/13/22.
//

import Foundation
import UIKit
import FlexiBLE

var fxb: FlexiBLE = {
    do {
        let fxb = try FlexiBLE()
        
        return fxb
    } catch {
        fatalError("Canot initialize aeble")
    }
}()
