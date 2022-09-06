//
//  AEButton.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/19/22.
//

import Foundation
import SwiftUI

struct FXBButton<Content: View>: View {
    let content: Content
    let action: ()->()
    
    init(action: @escaping ()->(), content: @escaping () -> Content) {
        self.content = content()
        self.action = action
    }
    
    var body: some View {
        Button(
            action: { action() },
            label: {
                content
                    .font(.custom("Arvo-Bold", size: 13))
            }
        )
        .padding(11)
        .background(Color(UIColor.systemIndigo))
        .foregroundColor(.white)
        .cornerRadius(8)
        .frame(height: 45.0)

    }
}

struct FXBButton_Previews: PreviewProvider {
    static var previews: some View {
        FXBButton(action: {}, content: { Text("What is up") })
    }
}
