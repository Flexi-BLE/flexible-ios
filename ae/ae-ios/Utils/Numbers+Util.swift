//
//  Number+Util.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/28/22.
//

import Foundation

extension Double {
    func uiReadable(precision: Int=2) -> String {
        return String(format: "%.\(precision)f", self)
    }
}
