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
            AEThingsView(vm: AEViewModel(with: URL(string: "https://gist.githubusercontent.com/blainerothrock/61383de0ac5358fed78a6a45f660b91d/raw/2c61b7a0f9552c54c51c1d0704dedd13611ad782/flexible-sample.json")!))
                .tabItem{
                    Image(systemName: "memorychip")
                    Text("Devices")
                }
//            DataStreamsView(vm: AEThingViewModel(with: AEDeviceConfig.mock.things.first!))
//                .tabItem {
//                    Image(systemName: "arrow.left.arrow.right")
//                    Text("Data Streams")
//                }
//            GlobalConfigurationsView(vm: AEThingViewModel(with: AEDeviceConfig.mock.things.first!))
//                .tabItem {
//                    Image(systemName: "gearshape")
//                    Text("Configurations")
//                }
//            GlobalConfigurationsView(vm: AEThingViewModel(with: AEDeviceConfig.mock.things.first!))
//                .tabItem {
//                    Image(systemName: "gearshape")
//                    Text("Configurations")
//                }
            ExperimentDashboardView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg.rectangle")
                    Text("Experiments")
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
