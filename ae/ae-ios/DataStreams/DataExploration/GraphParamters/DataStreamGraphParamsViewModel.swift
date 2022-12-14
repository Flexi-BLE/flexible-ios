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
    @Published var dsParams: DataStreamGraphParameters
    
    var spec: FXBDataStream
    
    @Published var dependentOptions: [FXBDataValueDefinition] = []
    @Published var dependentSelections: [String] = []
    
    @Published var filterOptions: [FXBDataValueDefinition] = []
    @Published var filterSelections: [String:[Int]] = [:]
    
    private var observers = Set<AnyCancellable>()
    
    init(dsParams: DataStreamGraphParameters, dataStream: FXBDataStream) {
        self.dsParams = dsParams
        self.spec = dataStream
        
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
        dsParams.dependentSelections = self.dependentSelections
        dsParams.filterSelections = self.filterSelections
    }
    
    private func parseSpec() {
        self.spec.dataValues.forEach { dv in
            switch dv.variableType {
            case .tag:
                filterOptions.append(dv)
                if dsParams.filterSelections[dv.name] == nil {
                    filterSelections[dv.name] = []
                } else {
                    filterSelections[dv.name] = []
                    for opt in dsParams.filterSelections[dv.name]! {
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
        
        for opt in dsParams.dependentSelections {
            if dependentOptions.map({ $0.name }).contains(opt) {
                dependentSelections.append(opt)
            }
        }
    }
    
    private func subscribe() {

    }
}
