//
//  FXBCheckboxEntry.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 9/2/22.
//

import SwiftUI

struct FXBCheckboxEntry: View {
    @StateObject var vm: DataValueOptionInformation
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 11)
            Image(systemName: vm.isChecked ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 21, height: 21)
                .foregroundColor(vm.isChecked ? Color(UIColor.systemBlue) : Color.secondary)
                .onTapGesture {
                    vm.isChecked.toggle()
                }
            Spacer()
                .frame(width: 11)
            Text(vm.value)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

struct FXBCheckboxEntry_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DataValueOptionInformation(value: "accel_x", isChecked: false)
        FXBCheckboxEntry(vm: vm)
    }
}
