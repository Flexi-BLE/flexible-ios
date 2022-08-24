//
//  Logger.swift
//  ntrain-exthub (iOS)
//
//  Created by Blaine Rothrock on 12/20/21.
//

import Foundation
import OSLog

let GeneralLogger = Logger(subsystem: "com.hesterlab.ntrain.exthub", category: "general")

let InferenceLogger = Logger(subsystem: "com.hesterlab.ntrain.exthub", category: "inference")
let UserInterfaceLogger = Logger(subsystem: "com.hesterlab.ntrain.exthub", category: "ui")
