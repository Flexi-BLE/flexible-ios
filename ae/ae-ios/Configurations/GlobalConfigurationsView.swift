//
//  ConfigurationsView.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import FlexiBLE

struct GlobalConfigurationsView: View {
    
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
        GlobalConfigurationsView(vm: AEThingViewModel(with: FXBSpec.mock.devices.first!))
    }
}
