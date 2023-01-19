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
    let fxb = FlexiBLE.shared
    InfluxDBConnection.shared.start()
//    fxb.setArchive(bytes: 250_000_000, keepInterval: 60 * 60)
    return fxb
}()
