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
            AEThingsView(vm: AEViewModel(with: URL(string: "https://pastebin.com/raw/djkzG9eN")!))
//            AEThingsView(vm: AEViewModel(with: "exthub.json"))
                .tabItem{
                    Image(systemName: "memorychip")
                    Text("Devices")
                }
            ExperimentsView()
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
