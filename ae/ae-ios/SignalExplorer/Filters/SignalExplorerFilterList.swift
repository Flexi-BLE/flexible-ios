//
//  SignalExplorerFilterList.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/19/22.
//

import SwiftUI
import flexiBLE_signal

struct SignalExplorerFilterList: View {
    @ObservedObject var model: SignalExplorerModel
    
    @State private var editPopoverShown: Bool = false
    @State private var selection: Int = 0
    @State private var isEditable = false
    
    
    var body: some View {
        AddAFilterLink(model: model)
        Divider()
        List {
            ForEach(Array(zip(model.filters.indices, model.filters)), id: \.0) { index, filter in
                FilterCompactDetails(filter: filter)
                    .onTapGesture {
                        withAnimation {
                            selection = index
                            editPopoverShown.toggle()
                        }
                    }
            }
            .onDelete(perform: { model.delete(at: $0) })
            .onMove(perform: {
                model.move(from: $0, to: $1)
                withAnimation { isEditable = false }
            })
            .onLongPressGesture(perform: {
                withAnimation { isEditable = true }
            })
        }
        .listStyle(.plain)
        .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
        .popover(isPresented: $editPopoverShown) {
            FilterEditView(
                model: model,
                filter: model.filters[selection],
                onClose: {
                    withAnimation {
                        editPopoverShown.toggle()
                    }
                },
                onUpdate: { newFilter in
//                    if let filter = newFilter {
//                        model.filters[selection].signalFilter = filter
//                        model.update()
//                    }
                }
            ).padding()
        }
    }
}
