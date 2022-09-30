//
//  DataStreamGraphParamsViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 9/29/22.
//

import Foundation
import FlexiBLE
import Combine

@MainActor class DataStreamGraphParamsViewModel: ObservableObject {
    @Published var model: DataStreamGraphParameters
    var spec: FXBDataStream
    
    @Published var isLive: Bool = false
    
    @Published var liveInterval: Double = 0.0
    @Published var start: Date = Date.now
    @Published var end: Date = Date.now.addingTimeInterval(-30)
    
    @Published var dependentOptions: [FXBDataValueDefinition] = []
    @Published var dependentSelections: [String] = []
    
    @Published var filterOptions: [FXBDataValueDefinition] = []
    @Published var filterSelections: [String:[Int]] = [:]
    
    private var observers = Set<AnyCancellable>()
    
    init(with model: DataStreamGraphParameters, dataStream: FXBDataStream) {
        self.model = model
        self.spec = dataStream
        
        self.isLive = self.model.state == .live ? true : false
        self.liveInterval = self.model.liveInterval
        self.start = self.model.start
        self.end = self.model.end
        
        parseSpec()
        subscribe()
    }
    
    func readableOptions(for optionName: String) -> [String] {
        guard let valueDef = spec.dataValues.first(where: { $0.name == optionName }),
              let valueOptions = valueDef.valueOptions else {
            return []
        }
        return valueOptions
    }
    
    func readableFilterSelections(for optionName: String) -> [String] {
        guard let selections = self.filterSelections[optionName],
            let valueDef = spec.dataValues.first(where: { $0.name == optionName }),
              let valueOptions = valueDef.valueOptions else {
            return []
        }
        return selections.map({ valueOptions[$0] })
    }
    
    func selectFilterOption(value: FXBDataValueDefinition, option: String) {
        guard let i = value.valueOptions?.firstIndex(where: { $0 == option }) else { return }
        self.filterSelections[value.name]?.append(i)
    }
    
    func deselectFilterOption(value: FXBDataValueDefinition, option: String) {
        guard let i = value.valueOptions?.firstIndex(where: { $0 == option }) else { return }
        self.filterSelections[value.name]?.removeAll(where: { $0 == i })
    }
    
    func selectDependentOption(option: FXBDataValueDefinition) {
        self.dependentSelections.append(option.name)
    }
    
    func deselectDependentOption(option: FXBDataValueDefinition) {
        self.dependentSelections.removeAll(where: { $0 == option.name })
    }
    
    func save() {
        model.state = self.isLive ? .live : .timeboxed
        model.dependentSelections = self.dependentSelections
        model.filterSelections = self.filterSelections
        model.liveInterval = self.liveInterval
        model.start = self.start
        model.end = self.end
    }
    
    private func parseSpec() {
        self.spec.dataValues.forEach { dv in
            switch dv.variableType {
            case .tag:
                filterOptions.append(dv)
                if model.filterSelections[dv.name] == nil {
                    filterSelections[dv.name] = []
                } else {
                    filterSelections[dv.name] = []
                    for opt in model.filterSelections[dv.name]! {
                        if dv.valueOptions?.count ?? opt > opt {
                            filterSelections[dv.name]?.append(opt)
                        }
                    }
                }
            case .value:
                dependentOptions.append(dv)
            case .none: break
            }
        }
        
        for opt in model.dependentSelections {
            if dependentOptions.map({ $0.name }).contains(opt) {
                dependentSelections.append(opt)
            }
        }
    }
    
    private func subscribe() {

    }
}
