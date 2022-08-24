//
//  UIDevice.swift
//  ntrain-exthub (iOS)
//
//  Created by Blaine Rothrock on 2/24/22.
//

import Foundation
import UIKit

extension UIDevice {
    var id: String {
        return self.identifierForVendor?.uuidString ?? "--unknown iOS--"
    }
}
