//
//  ChartControls.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/8/22.
//

import SwiftUI
import FlexiBLE

struct ChartControls: View {
    private enum PanelState {
        case yAxis
        case xAxis
        case ewma
        case hidden
    }
    
    @StateObject var vm: DataStreamGraphViewModel
    
    @State var isPaused = false
    @State private var panelState: PanelState = .hidden
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if vm.chartParameters.state == .live || vm.chartParameters.state == .livePaused {
                    ChartControlButton(imageName: isPaused ? "play" : "pause", size: 50) {
                        if isPaused { vm.resume() }
                        else { vm.pause() }
                        isPaused.toggle()
                    }
                }
            }
            Spacer()
            if panelState != .hidden {
                Spacer()
                ChartControlButton(
                    imageName: "xmark",
                    size: 50,
                    action: {
                        panelState = .hidden
                        vm.parametersUpdated()
                    },
                    longPressAction: nil
                )
            }
            HStack {
                switch panelState {
                case .hidden: EmptyView()
                case .yAxis: ChartYAxisAdjustmentPanel(chartParams: vm.chartParameters)
                case .xAxis: ChartXAxisAdjustmentPanel(chartParams: vm.chartParameters)
                case .ewma: ChartEWMAAdjustmentPanel(chartParams: vm.chartParameters)
                }
                Spacer()
                VStack {
                    switch panelState {
                    case .hidden:
                        ChartControlButton(
                            imageName: "line.3.horizontal.decrease.circle",
                            size: 50,
                            action: {

                            },
                            longPressAction: {
                                panelState = .ewma
                            }
                        )
                        ChartControlButton(
                            imageName: "timeline.selection",
                            size: 50,
                            action: {

                            },
                            longPressAction: {
                                panelState = .xAxis
                            }
                        )
                        ChartControlButton(
                            imageName: "rectangle.compress.vertical",
                            size: 50,
                            action: {
                                vm.resetYRange()
                            },
                            longPressAction: {
                                panelState = .yAxis
                            }
                        )
                    case .yAxis, .xAxis, .ewma: EmptyView()
                    }
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
