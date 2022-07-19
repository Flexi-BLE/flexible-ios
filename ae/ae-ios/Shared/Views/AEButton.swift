//
//  AEButton.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/19/22.
//

import Foundation
import SwiftUI

struct AEButton<Content: View>: View {
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
            }
        )
        .padding()
        .frame(height: 45.0)
        .foregroundColor(.white)
        .background(.gray)
        .cornerRadius(10.0)
    }
}

struct AEButton_Previews: PreviewProvider {
    static var previews: some View {
        AEButton(action: {}, content: { Text("What is up") })
    }
}
