//
//  ProfileDetailCell.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 1/30/23.
//

import SwiftUI
import FlexiBLE

struct ProfileDetailCell: View {
    
    var profile: FlexiBLEProfile
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(profile.name)").font(.title3).bold()
            Text("\(profile.id)").font(.system(size: 10))
            HStack {
                Text("Specification Id").font(.system(size: 10))
                Text(profile.specification.id).font(.system(size: 10))
                Spacer()
            }
            HStack {
                Text("Created at").font(.system(size: 10))
                Text("\(profile.createdAt.getShortDateAndTime())").font(.system(size: 10))
                Spacer()
            }
        }
    }
}
