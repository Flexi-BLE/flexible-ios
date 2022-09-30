//
//  FXBLEConnectionView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/21/22.
//

import SwiftUI
import FlexiBLE

struct FXBLEConnectionView: View {
    var spec: FXBSpec
    @State var isEnabled: Bool = true
    @State var angle: Double = 0
    
//    @StateObject private var conn: FXBConnectionManager = fxb.conn
    
    var rotationAnimation: Animation {
        Animation.linear(duration: 1.0)
        .repeatForever(autoreverses: false)
    }
    
    init(spec: FXBSpec) {
        self.spec = spec
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
                            .rotationEffect(.degrees(angle))
//                            .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: angle)
//                            .onAppear() { angle = 360 }
//                            .onDisappear() { angle = 0 }
                    }
                    Spacer()
                    Toggle("Enabled", isOn: $isEnabled)
                        .labelsHidden()
                        .disabled(fxb.conn.centralState != .poweredOn)
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
        if isEnabled { fxb.startScan(with: spec) }
        else { fxb.stopScan() }
    }
}

struct FXBLEConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        FXBLEConnectionView(spec: FXBSpec.mock)
    }
}
