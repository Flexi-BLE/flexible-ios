//
//  MultiSelectionView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/29/22.
//

import SwiftUI

struct MultiSelectionView: View {
    @Environment(\.dismiss) var dismiss
    
    var title: String
    @State var selections: [String]
    @State var options: [String]
    
    var didSelect: (String) -> ()
    var didDeselect: (String) -> ()
    
    var body: some View {
        VStack {
            Text("Select \(title)")
                .font(.title2)
                .padding()
            List {
                Button {
                    for s in selections { didDeselect(s) }
                    selections = []
                } label: {
                    Text("Clear")
                }
                
                Section(header: Text("Options")) {
                    ForEach(options, id: \.self) { opt in
                        HStack {
                            Text("\(opt)").bold()
                            Spacer()
                            if selections.contains(opt) {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selections.contains(opt) {
                                selections.removeAll(where: { $0 == opt })
                                didDeselect(opt)
                            } else {
                                selections.append(opt)
                                didSelect(opt)
                            }
                        }
                    }
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct MultiSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
