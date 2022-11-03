//
//  Color.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static var tab10: [Color] = [
        Color(hex: "1f77b4"), // tab:blue
        Color(hex: "ff7f0e"), // tab:orange
        Color(hex: "2ca02c"), // tab:green
        Color(hex: "d62728"), // tab:red
        Color(hex: "9467bd"), // tab:purple
        Color(hex: "8c564b"), // tab:brown
        Color(hex: "e377c2"), // tab:pink
        Color(hex: "7f7f7f"), // tab:gray
        Color(hex: "bcbd22"), // tab:olive
        Color(hex: "17becf"), // tab:cyan
    ]
}
