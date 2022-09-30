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
    @Published var independentOptions: [FXBDataValueDefinition] = []
    @Published var independentSelections: [String] = []
    
    @Published var dependentOptions: [FXBDataValueDefinition] = []
    @Published var dependentSelections: [String:[String]] = [:]
    
    private var observers = Set<AnyCancellable>()
    
    init(with model: DataStreamGraphParameters, dataStream: FXBDataStream) {
        self.model = model
        self.spec = dataStream
        
        parseSpec()
        subscribe()
    }
    
    private func parseSpec() {
        self.spec.dataValues.forEach { dv in
            switch dv.variableType {
            case .tag:
                dependentOptions.append(dv)
                if model.dependentSelections[dv.name] == nil {
                    dependentSelections[dv.name] = []
                }
            case .value:
                independentOptions.append(dv)
            case .none: break
            }
        }
    }
    
    private func subscribe() {

    }
}
