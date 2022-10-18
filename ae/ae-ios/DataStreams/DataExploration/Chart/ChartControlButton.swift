//
//  ChartControlButton.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/13/22.
//

import SwiftUI

struct ChartControlButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .background(Color(UIColor(red: 250/255, green: 128/255, blue: 114/255, alpha: 1.0)))
            .clipShape(Circle())
            .shadow(color: .gray, radius: 3, x: -2, y: 2)
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
    }
}

struct ChartControlButton: View {
    let action: ()->()
    let longPressAction: (()->())?
    let imageName: String
    let size: CGFloat
    
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactRigid = UIImpactFeedbackGenerator(style: .rigid)
    
    init(imageName: String, size: CGFloat=50, action: @escaping ()->(), longPressAction: (()->())?=nil) {
        self.action = action
        self.longPressAction = longPressAction
        self.imageName = imageName
        self.size = size
    }
    
    var body: some View {
        Button(
            action: {
                // handled in gestures
            },
            label: {
                Image(systemName: imageName)
                    .frame(width: size, height: size)
                    .font(.system(size: size/2.2))
            }
        )
        .buttonStyle(ChartControlButtonStyle())
        .simultaneousGesture(TapGesture().onEnded {
            impactLight.impactOccurred()
            action()
        })
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5).onEnded({ value in
            if let action = self.longPressAction {
                impactRigid.impactOccurred()
                longPressAction?()
            }
        }))
    }
}

struct ChartControlButton_Previews: PreviewProvider {
    static var previews: some View {
        ChartControlButton(imageName: "square.and.arrow.up", size: 50, action: {  })
    }
}
