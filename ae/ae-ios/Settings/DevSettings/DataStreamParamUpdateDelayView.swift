//
//  DataStreamConfigUpdateDelayCell.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/21/22.
//

import SwiftUI

enum DataStreamParamUpdateDelay {
    static private var userDefaultsKey: String = "DataStreamConfigUpdateDelay"
    
    static func store(ms: Int) {
        UserDefaults.standard.set(ms, forKey: Self.userDefaultsKey)
    }
    
    static func get() -> Int {
        guard let val = UserDefaults
            .standard
            .object(forKey: Self.userDefaultsKey) as? Int else {
            
            Self.store(ms: 500)
            return 500
        }
        
        return val
    }
}


struct DataStreamParamUpdateDelayView: View {
    private let options = [500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
    
    @State var selection: Int
    
    init() {
        self.selection = DataStreamParamUpdateDelay.get()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Data Stream Parameters Update Delay: ")
                .font(.title3.bold())
            Text("The wait time before reading data stream parameters after an update. This should be longer for longer BLE latencies. Defaults to 500 ms.")
                .lineLimit(100)
                .font(.body)
            Divider()
            Picker(selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(String(option)).tag(option)
                }
            } label: {
                Text("Delay (ms)")
            }
            .pickerStyle(.menu)
            .onChange(of: selection) { newValue in
                DataStreamParamUpdateDelay.store(ms: newValue)
            }
        }
    }
}

struct DataStreamConfigUpdateDelayCell_Previews: PreviewProvider {
    static var previews: some View {
        DataStreamParamUpdateDelayView()
    }
}
