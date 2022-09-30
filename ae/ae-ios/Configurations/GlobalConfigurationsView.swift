//
//  ConfigurationsView.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import FlexiBLE

struct GlobalConfigurationsView: View {
    
    @StateObject var vm: FXBDeviceViewModel
    
    var body: some View {
        VStack {
            HelpHeaderView(title: "Configurations", helpText: "todo ...")
            ScrollView {
                Spacer()
                Text("Configurations")
                Spacer()
            }
        }
    }
}
