//
//  ConfigurationsView.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import aeble

struct ConfigurationsView: View {
    
    @StateObject var vm: AEThingViewModel
    
    var body: some View {
        VStack {
            HelpHeaderView(title: "Configurations", helpText: "todo ...")
            AEThingBannerView(vm: vm)
            ScrollView {
                Spacer()
                Text("Configurations")
                Spacer()
            }
        }
    }
}

struct ConfigurationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationsView(vm: AEThingViewModel(with: AEDeviceConfig.mock.things.first!))
    }
}
