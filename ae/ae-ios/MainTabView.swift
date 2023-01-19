//
//  MainTabView.swift
//  ae
//
//  Created by blaine on 4/13/22.
//

import SwiftUI
import FlexiBLE

struct MainTabView: View {
    @StateObject var locationManager = LocationManager()
    var body: some View {
        TabView {
            DevicesView(vm: FlexiBLESpecViewModel())
//            AEThingsView(vm: AEViewModel(with: "exthub.json"))
                .tabItem{
                    Image(systemName: "memorychip")
                    Text("Devices")
                }
            

//            DeviceDataView()
//                .tabItem {
//                    Image(systemName: "externaldrive.fill.badge.timemachine")
//                    Text("Data")
//                }
            ExperimentsView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg.rectangle")
                    Text("Experiments")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "ellipsis.circle.fill")
                    Text("More")
                }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
