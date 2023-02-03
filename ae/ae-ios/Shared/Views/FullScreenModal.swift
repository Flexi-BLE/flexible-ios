//
//  FullScreenModal.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 2/2/23.
//

import SwiftUI

struct FullScreenModal<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    
    let content: Content
    
    init(content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Dismiss")
            }
            .buttonStyle(PrimaryButtonStyle())

        }
    }
}
struct FullScreenModal_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenModal() { Text("Hello") }
    }
}
