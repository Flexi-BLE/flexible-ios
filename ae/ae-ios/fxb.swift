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
    if LiveUpload.get() {
        LiveUpload.globalUploader.start()
    } else {
        LiveUpload.globalUploader.stop()
    }
    return fxb
}()
