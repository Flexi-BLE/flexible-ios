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
            AEThingsView(vm: AEViewModel(with: URL(string: "https://pastebin.com/raw/WAbEtR3W")!))
//            AEThingsView(vm: AEViewModel(with: "exthub.json"))
                .tabItem{
                    Image(systemName: "memorychip")
                    Text("Devices")
                }
//            DataStreamsView(vm: AEThingViewModel(with: FXBSpec.mock.devices.first!))
//                .tabItem {
//                    Image(systemName: "arrow.left.arrow.right")
//                    Text("Data Streams")
//                }
//            GlobalConfigurationsView(vm: AEThingViewModel(with: FXBSpec.mock.devices.first!))
//                .tabItem {
//                    Image(systemName: "gearshape")
//                    Text("Configurations")
//                }
//            GlobalConfigurationsView(vm: AEThingViewModel(with: FXBSpec.mock.devices.first!))
//                .tabItem {
//                    Image(systemName: "gearshape")
//                    Text("Configurations")
//                }
            ExperimentsView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg.rectangle")
                    Text("Experiments")
                }
            
//            MapWithUserLocationView()
//                .tabItem {
//                    Image(systemName: "map")
//                    Text("Location")
//                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
