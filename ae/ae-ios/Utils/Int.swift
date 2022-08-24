//
//  Int.swift
//  ae
//
//  Created by Blaine Rothrock on 4/27/22.
//

import Foundation

extension Int {
    var fuzzy: String {
        switch self {
        case 0..<1000: return "\(self)"
        case 1000..<1000000: return "\(self / 1000)K"
        case 1000000..<1000000000: return "\(self / 1000000)M"
        case 1000000000..<Int.max: return "\(self / 1000000000)B"
        default: return "\(self)"
        }
    }
}
