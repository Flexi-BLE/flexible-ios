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
    fxb.setArchive(bytes: 2_000_000, keepInterval: 60) // database is 2Mb backup every 2 minutes (only when streaming)
    return fxb
}()
