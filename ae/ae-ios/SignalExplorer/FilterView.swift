//
//  FilterView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import flexiBLE_signal

//struct FilterView: View {
//    @Environment(\.dismiss) var dismiss
//    
//    @State var filterType: SignalFilterType
//    @State var filter: (any SignalFilter)? = nil
//    var ts: TimeSeries<Float>
//    
//    var onDismiss: @MainActor (_ filter: TimeSeries<Float>.FilterType) -> ()
//    
//    var body: some View {
//        List {
//            VStack(alignment: .leading) {
//                Text("Time Series")
//                    .font(.callout)
//                    .foregroundStyle(.secondary)
//                Text("Add a Filter")
//                    .font(.title2.bold())
//                Text("Signal Frequency: \(Float(1.0/ts.frequency()))Hz")
//                    .font(.body)
//                
//                FilterTypePicker(filterType: $filterType)
//                    .onChange(of: $filterType) { newValue in
////                        filterDetails = newValue.createTsFilter()
//                    }
//            }
//            .listRowSeparator(.hidden)
//            
//            switch filterType {
//            case .none: EmptyView()
//            default:
//                Section("Description") {
//                    Text(filterType.description)
//                        .font(.body)
//                }.listRowSeparator(.hidden)
//            }
//            
//            switch filterType {
//            case .none, .zscore, .demean, .minMaxScaling: EmptyView()
//            default:
//                Section("Options") {
//                    switch filterType {
//                    case .movingAvgerage:
//                        MovingAverageOptionsView(filter: $filterDetails, window: "100")
//                    case .lowPass:
//                        LowPassOptionsView(filter: $filterDetails, cutoff: "20", transition: "2")
//                    default: EmptyView()
//                    }
//                }.listRowSeparator(.hidden)
//            }
//            
//            switch filterType {
//            case .none: EmptyView()
//            default:
//                if let fd = filterDetails {
//                    Section("Filter Impulse Response") {
//                        switch fd {
//                        case let .movingAverage(window):
//                            MovingAverageIRView(window: window)
//                        case let .lowPass(cutoff, transition):
//                            LowPassIRView(frequency: Float(1.0/ts.frequency()), cutoff: cutoff, transition: transition)
//                        default: EmptyView()
//                        }
//                    }.listRowSeparator(.hidden)
//                }
//            }
//            
//            switch filterType {
//            case .none: EmptyView()
//            default:
//                Section("Action") {
//                    Button("Save", action: {
//                        if let filter = self.filterDetails {
//                            onDismiss(filter)
//                        }
//                        dismiss()
//                    })
//                    Button("Cancel", action: {
//                        dismiss()
//                    })
//                }
//            }
//            
//            
//        }
//        .listStyle(.plain)
//        .navigationBarTitle("Filter Options", displayMode: .inline)
//    }
//}
//
//struct FilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterView(ts: TimeSeries<Float>(persistence: 0), onDismiss: { filter in  })
//    }
//}
