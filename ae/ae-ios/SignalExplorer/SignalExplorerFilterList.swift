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
                filterIdx: selection,
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

struct FilterCompactDetails: View {
    var filter: FilterSelectionDetails
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(filter.selection.type.rawValue)")
                    .font(.headline)
//                if let details = filter.details {
//                    Text(details)
//                        .font(.callout).foregroundColor(.gray)
//                }
            }
        }
    }
}

struct AddAFilterLink: View {
    var model: SignalExplorerModel
    
    @State var filterType: SignalFilterType = SignalFilterType.none
    
    var body: some View {
        HStack {
            Text("Select a Filter:")
                .font(.body.bold())
            Spacer()
            Picker("Filter Type", selection: $filterType) {
                Text("--").tag(SignalFilterType.none)
                Text("Min Max Scaling").tag(SignalFilterType.minMaxScaling)
                Text("Z-Score Normalization").tag(SignalFilterType.zscore)
                Text("Moving Average").tag(SignalFilterType.movingAverage)
                Text("Low Pass").tag(SignalFilterType.lowPass)
                Text("High Pass").tag(SignalFilterType.highPass)
                Text("Band Pass").tag(SignalFilterType.bandPass)
                Text("Band Reject").tag(SignalFilterType.bandReject)
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .onChange(of: filterType) { newValue in
                guard newValue != .none else { return }
                model.filterAdded(newValue)
                self.filterType = .none
            }
        }
    }
}

struct FilterEditView: View {
    @State var model: SignalExplorerModel
    @State var filterIdx: Int
    
    @State var updatedFilter: TimeSeries<Float>.FilterType? = nil
    
    var onClose: ()->()
    var onUpdate: (TimeSeries<Float>.FilterType?)->()
    
    var body: some View {
        ScrollView {
            HStack {
                FilterCompactDetails(filter: model.filters[filterIdx])
                Spacer()
                Button(
                    action: { onClose() },
                    label: { Image(systemName: "xmark").font(.body) }
                )
            }
            
            TimeFreqChartView(
                rawSignal: model.rawSignal,
                filteredSignal: model.filteredSignal
            )
            
            Divider()
            Spacer().frame(height: 45.0)
//            switch model.filters[filterIdx].signalFilter {
//            case let .movingAverage(window):
//                MovingAverageCompactEditView(
//                    window: window,
//                    length: 500,
//                    onChange: { window in
//                        updatedFilter = .movingAverage(window: window)
//                        onUpdate(updatedFilter)
//                    }
//                )
//            case let .lowPass(cutoff, transition):
//                LowPassCompactEditView(
//                    fL: cutoff,
//                    bL: transition,
//                    frequency: Float(1.0/model.placeholderSignal.ts.frequency())) { cutoff, transition in
//                        updatedFilter = .lowPass(cutoff: cutoff, transition: transition)
//                        onUpdate(updatedFilter)
//                    }
//            default: Text("nope.")
//            }
            Spacer()
        }
    }
}
