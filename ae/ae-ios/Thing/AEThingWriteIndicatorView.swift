//
//  AEThingWriteIndicatorView.swift
//  ae
//
//  Created by Blaine Rothrock on 4/26/22.
//

import SwiftUI
import FlexiBLE

struct AEThingWriteIndicatorView: View {
    
    @StateObject var vm: AEThingViewModel
    @State var lastDate: Date? = nil
    @State var blink: Bool = false
    
    var size: CGFloat = 10
    
    var body: some View {
        Circle()
            .frame(width: size, height: size)
            .foregroundColor(blink ? Color(hex: "409B6E") : .clear)
            .onReceive(vm.$lastWrite) { date in
                if lastDate != date, date != nil {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        blink = true
                    }
                    lastDate = date
                } else {
                    blink = false
                }
            }
    }
}

struct AEThingWriteIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        AEThingWriteIndicatorView(vm: AEThingViewModel(with: FXBSpec.mock.devices.first!))
            .previewLayout(.sizeThatFits)
    }
}
