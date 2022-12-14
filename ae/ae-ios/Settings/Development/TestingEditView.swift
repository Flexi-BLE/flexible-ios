//
//  TestingEditView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/6/22.
//

import SwiftUI

struct TestingEditView: View {
    @State private var isShowingFloatingView = false

    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    self.isShowingFloatingView.toggle()
                }
                
            }) {
                Text("Show Floating View")
            }
            .padding()

            if isShowingFloatingView {
                FloatingView(title: "title1")
                    .padding(25)
            }
        }
    }
}

struct FloatingView: View {
    let title: String
    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding()

            Spacer()
        }
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .offset(x: dragOffset.width, y: 0)
        .gesture(
            DragGesture()
                .updating($dragOffset, body: { (value, state, transaction) in
                    state = value.translation
                })
                .onEnded { value in
                    if value.translation.width > 100 {
//                        self.isShowingFloatingView = false
                    }
                }
        )
        .transition(.move(edge: .trailing))
    }
}
