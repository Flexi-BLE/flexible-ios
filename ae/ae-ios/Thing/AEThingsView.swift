//
//  AEThingsView.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI
import aeble

struct AEThingsView: View {
    @StateObject var vm: AEViewModel
    
    var body: some View {
        VStack {
            HelpHeaderView(title: "Devices", helpText: "todo ...")
            TabView {
                ScrollView {
                    ForEach(vm.config.things, id: \.name) { thing in
                        AEThingDetailCellView(vm: AEThingViewModel(with: thing))
                            .modifier(Card())
                    }
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

struct AEThingsView_Previews: PreviewProvider {
    static var previews: some View {
        AEThingsView(vm: AEViewModel(AEDeviceConfig.mock))
    }
}