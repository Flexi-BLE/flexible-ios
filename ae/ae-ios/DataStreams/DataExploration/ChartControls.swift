//
//  ChartControls.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/8/22.
//

import SwiftUI
import FlexiBLE

struct ChartControls: View {
    @StateObject var vm: DataStreamGraphViewModel
    
    @State var isPaused = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if vm.parameters.state == .live {
                    Text("Live")
                        .padding()
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 4.0).foregroundColor(.green))
                }
            }
            Spacer()
            HStack {
                Spacer()
                VStack {
                    if vm.parameters.state == .live || vm.parameters.state == .livePaused {
                        Button(
                            action: {
                                if isPaused { vm.resume() }
                                else { vm.pause() }
                                isPaused.toggle()
                            },
                            label: {
                                Image(systemName: isPaused ? "play" : "pause")
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(Color.white)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            }
                        ).buttonStyle(PlainButtonStyle())
                    }
                    Button(
                        action: { vm.resetYRange() },
                        label: {
                            Image(systemName: "rectangle.compress.vertical")
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    ).buttonStyle(PlainButtonStyle())
                }
            }.padding()
        }.padding()
    }
}

struct ChartControls_Previews: PreviewProvider {
    static var previews: some View {
        ChartControls(
            vm: DataStreamGraphViewModel(
                dataStream: FXBSpec.mock.devices[0].dataStreams[0],
                deviceName: "nothing"
            )
        )
    }
}
