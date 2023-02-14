//
//  FXBLEConnectionView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/21/22.
//

import SwiftUI
import FlexiBLE

struct FXBLEConnectionView: View {
    @EnvironmentObject var profile: FlexiBLEProfile
    
    @State var isEnabled: Bool = false
    @State var angle: Double = 0
    
    var rotationAnimation: Animation {
        Animation.linear(duration: 1.0)
        .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                HStack {
                    Text("FlexiBLE")
                        .font(.title2)
                    if isEnabled {
                        Image(systemName: "circle.grid.cross.up.filled")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Toggle("Enabled", isOn: $isEnabled)
                        .labelsHidden()
                        .onChange(of: isEnabled) { value in
                            enabledChanged()
                        }
                }
                switch isEnabled {
                case true: Text("Scanning for devices").font(.body).foregroundColor(.gray)
                case false: Text("Enabled to Scan").font(.body).foregroundColor(.gray)
                }
            }.padding()
        }
        .onTapGesture {
            isEnabled.toggle()
        }
    }
    
    private func enabledChanged() {
        if isEnabled {
            profile.startScan()
        }
        else {
            profile.stopScan()
        }
    }
}

struct FXBLEConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        FXBLEConnectionView()
    }
}
