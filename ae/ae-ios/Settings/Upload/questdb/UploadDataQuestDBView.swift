//
//  UploadDataQuestDBView.swift
//  Flexi-BLE
//
//  Created by blaine on 9/1/22.
//

import SwiftUI

struct UploadDataQuestDBView: View {
    @StateObject var vm: UploadDataQuestDBViewModel
    
    var body: some View {
        ScrollView {
            Text("⏳ QuestDB Coming Soon ⏳")
            Spacer()
        }
    }
}

struct UploadDataQuestDBView_Previews: PreviewProvider {
    static var previews: some View {
        UploadDataQuestDBView(vm: UploadDataQuestDBViewModel())
    }
}
