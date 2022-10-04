//
//  FXBButtonStyle.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/1/22.
//

import Foundation
import SwiftUI

struct FCBButtonStyle: ButtonStyle {
    var bgColor: Color
    var fontColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(11)
            .font(.system(size: 13))
            .background(bgColor)
            .foregroundColor(fontColor)
            .cornerRadius(8)
    }
}
