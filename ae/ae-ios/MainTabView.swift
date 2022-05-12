//
//  MainTabView.swift
//  ae
//
//  Created by blaine on 4/13/22.
//

import SwiftUI
import aeble

struct MainTabView: View {
    
    var body: some View {
        TabView {
            AEThingsView(vm: AEViewModel(AEDeviceConfig.mock))
                .tabItem{
                    Image(systemName: "memorychip")
                    Text("Devices")
                }
            DataStreamsView(vm: AEThingViewModel(with: AEDeviceConfig.mock.things.first!))
                .tabItem {
                    Image(systemName: "arrow.left.arrow.right")
                    Text("Data Streams")
                }
            ConfigurationsView(vm: AEThingViewModel(with: AEDeviceConfig.mock.things.first!))
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Configurations")
                }
            ExperimentView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg.rectangle")
                    Text("Experiment")
                }
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
