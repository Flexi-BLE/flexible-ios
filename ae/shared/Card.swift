//
//  Card.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI

struct Card: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black)
            )
            .padding()
    }
}
