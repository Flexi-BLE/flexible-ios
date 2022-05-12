//
//  AEThingBanner.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import aeble

struct AEThingBannerView: View {
    
    @StateObject var vm: AEThingViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text("For Selected Device")
                        .font(.system(size: 9))
                    
                    Text("\(vm.thing.name)")
                        .font(.title)
                    
                    HStack {
                        Text("Status: ")
                            .font(.body)
                            .bold()
                        Text("\(vm.connectionStatus)")
                    }
                    
                }
                .padding()
                Spacer()
                
                HStack {
                    Text("Recieved")
                        .font(.system(size: 11))
                    AEThingWriteIndicatorView(vm: vm)
                }
                
                HStack {
                    Text("Upload")
                        .font(.system(size: 11))
                    AEThingWriteIndicatorView(vm: vm)
                }
                    
            }
            
        Divider()
        }
    }
}

struct AEThingBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AEThingBannerView(vm: AEThingViewModel(with: AEDeviceConfig.mock.things.first!))
            .previewLayout(.sizeThatFits)
    }
}
