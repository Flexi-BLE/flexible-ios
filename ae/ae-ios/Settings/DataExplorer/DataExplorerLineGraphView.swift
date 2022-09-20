//
//  DataExplorerLineGraphView.swift
//  ae
//
//  Created by Blaine Rothrock on 4/27/22.
//

import SwiftUI
import FlexiBLE
import Combine

struct DataExplorerLineGraphView: View {
    @StateObject var vm: AEDataStreamViewModel
    
    @State var data: [Float] = []
    @State private var selectedField: String
    
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    init(vm: AEDataStreamViewModel) {
        self._vm = StateObject(wrappedValue: vm)
        timer = Timer.publish(
            every: 1,
            on: .main,
            in: .common
        ).autoconnect()
        selectedField = vm.dataStream.dataValues[0].name
    }
    
    var body: some View {
        VStack {
            HStack {
                Picker("Field", selection: $selectedField) {
                    ForEach(vm.dataStream.dataValues, id: \.name) { dv in
                        Text(dv.name).tag(dv.name)
                    }
                }
                Spacer()
                FXBButton {
                    Task {
                        self.data = await vm.fetchData(
                            limit: 200,
                            offset: 0,
                            measurement: selectedField
                        )
                    }
                } content: {
                    Text("Refresh")
                }
            }.padding()
            Divider()
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
        let ds = FXBSpec.mock.devices[0].dataStreams[0]
        let vm = AEDataStreamViewModel(ds, deviceName: "none", deviceVM: FXBDeviceViewModel(with: FXBSpec.mock.devices.first!))
        DataExplorerLineGraphView(vm: vm)
    }
}
