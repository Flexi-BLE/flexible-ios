//
//  DataExplorerLineGraphView.swift
//  ae
//
//  Created by Blaine Rothrock on 4/27/22.
//

import SwiftUI
import aeble
import Combine

struct DataExplorerLineGraphView: View {
    @StateObject var vm: AEDataStreamViewModel
    @State var data: [Float] = []
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    init(vm: AEDataStreamViewModel) {
        self._vm = StateObject(wrappedValue: vm)
        timer = Timer.publish(
            every: 1,
            on: .main,
            in: .common
        ).autoconnect()
    }
    
    var body: some View {
        VStack {
            Button(
                action: { Task { self.data = await vm.fetchData(limit: 200, offset: 0) } },
                label: { Text("Refresh") }
            )
            Spacer()
            GeometryReader { reader in
                LineView(
                    data: data,
                    frame: .constant(
                        CGRect(
                            x: 0,
                            y: 0,
                            width: reader.frame(in: .local).width,
                            height: reader.frame(in: .local).height
                        )
                    )
                )
                .task {
                    self.data = await vm.fetchData(
                        limit: 200,
                        offset: 0
                    )
                }
                .onReceive(timer) { _ in
                    Task {
                        self.data = await vm.fetchData(
                            limit: 200,
                            offset: 0
                        )
                    }
                }
            }
        }.navigationBarTitle(vm.dataStream.name, displayMode: .inline)
    }
}

struct DataExplorerLineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = AEDeviceConfig.mock.things[0].dataStreams[0]
        let vm = AEDataStreamViewModel(ds, deviceName: "none")
        DataExplorerLineGraphView(vm: vm)
    }
}
