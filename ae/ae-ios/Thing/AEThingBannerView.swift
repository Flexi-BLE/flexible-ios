//
//  AEThingBanner.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import SwiftUI
import FlexiBLE

struct AEThingBannerView: View {
    
    @StateObject var vm: AEThingViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text("For Selected Device")
                        .font(.system(size: 9))
                    
                    Text("\(vm.thing.name)")
                        .font(.custom("AlegreyaSans-Medium", size: 27))
                    
                    HStack {
                        Text("Status: ")
                            .font(.custom("AlegreyaSans-Bold", size: 17))
                        Text("\(vm.connectionStatus)")
                            .font(.custom("Arvo", size: 15))

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
        AEThingBannerView(vm: AEThingViewModel(with: FXBSpec.mock.devices.first!))
            .previewLayout(.sizeThatFits)
    }
}
