//
//  DataStreamGraphPropertyViewModel.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 9/2/22.
//

import Foundation
import Combine
import FlexiBLE

@MainActor class DataExplorerGraphPropertyViewModel: ObservableObject {
    private var _dataStream: FXBDataStream
    private var _configName: String
    @Published var variableModel: GraphPropertyVariableModel = GraphPropertyVariableModel()
    @Published var visualModel: GraphPropertyVisualModel = GraphPropertyVisualModel()
    private var queryYMin: Double?
    private var queryYMax: Double?

    init(dataStream: FXBDataStream) {
        self._dataStream = dataStream
        self._configName = dataStream.name
        parsePropertyAndReadingsFromStream()
        Task {
            await getDistinctPropertyValuesCaptured()
            checkPreviousStoredConfiguration()
        }
    }
    
    private func parsePropertyAndReadingsFromStream() {
        let dataValues = _dataStream.dataValues
        for dv in dataValues {
            if dv.variableType == .tag {
                variableModel.supportedProperty.append(dv.name)
                variableModel.selectedProperty = dv.name
            } else if dv.variableType == .value {
                variableModel.supportedReadings.append(DataValueOptionInformation(value: dv.name))
            }
        }
    }
    
    private func getDistinctPropertyValuesCaptured() async {
        guard !variableModel.supportedProperty.isEmpty else {
            return
        }
        for eachProperty in variableModel.supportedProperty {
            let result = await fxb.read.getDistinctValuesForColumn(for: eachProperty, table_name: _configName)
            guard let values = result else {
                return
            }
            DispatchQueue.main.async { [self] in
                let distinctValues = values.map { DataValueOptionInformation(value: $0) }
                variableModel.propertyDict[eachProperty] = distinctValues
            }
        }
    }

    private func checkPreviousStoredConfiguration() {
        do {
            let storedModel = try UserDefaults.standard.getCustomObject(forKey: "\(_configName)_model", castTo: GraphPropertyUserDefaultModel.self)
            loadPreviousStoredConfiguration(prevModel: storedModel)
        } catch {
            print("ASD")
        }
    }
    
    
    private func loadPreviousStoredConfiguration(prevModel: GraphPropertyUserDefaultModel) {
        for eachSelectedReading in prevModel.selectedReadings {
            let reading = variableModel.supportedReadings.filter({ $0.value == eachSelectedReading })
            if !reading.isEmpty {
                reading[0].isChecked = true
            }
        }
        
        visualModel.graphState = prevModel.graphSelectionState
        visualModel.liveInterval = prevModel.liveInterval
        
        if let selectedProperty = prevModel.selectedProperty, let spv = prevModel.supportedPropertyValues {
            variableModel.selectedProperty = selectedProperty
            for eachSelectedPropertyValue in spv {
                guard let supportedValues = variableModel.propertyDict[eachSelectedPropertyValue.key] else {
                    return
                }
                let selectedValues = eachSelectedPropertyValue.value
                for eachSelectedValue in selectedValues {
                    let values = supportedValues.filter({ $0.value == eachSelectedValue })
                    if !values.isEmpty {
                        values[0].isChecked = true
                    }
                }
            }
        }
    }
    
//    private func createDefaultConfigurationForGraph() -> GraphPropertyUserDefaultModel {
//
//    }
    
    public func getConfigName() -> String {
        return _configName
    }
    
    
    public func checkDependencyOfReadingsOnProperty(for readings: [String], selectedProperty: String?) -> Bool {
        for dsc in _dataStream.dataValues {
            if readings.contains(dsc.name), selectedProperty != nil, let props = selectedProperty, !(dsc.dependsOn?.contains(props) != nil) {
                return false
            }
        }
        return true
    }
    
    public func getSelectedValuesFromProperty(forKey: String?) -> [String]? {
        if let key = forKey, variableModel.propertyDict[key] != nil {
            let values = variableModel.propertyDict[key]
            if let val = values {
                let filtered = val.filter ({ $0.isChecked == true })
                return filtered.map { $0.value }
            }
        }
        return nil
    }
    
    public func getSelectedReadings() -> [String] {
        let checkedVal = variableModel.supportedReadings.filter({ $0.isChecked })
        return checkedVal.map { $0.value }
    }
    
    public func getYMin() -> Double {
        guard visualModel.shouldFilterByYAxisRange, let yMin = Double(visualModel.userYMin) else {
            return getSelectedReadings().count != 0 ? queryYMin ?? 0.0 : 0.0
        }
        return yMin
    }
    
    public func getYMax() -> Double {
        guard visualModel.shouldFilterByYAxisRange, let yMax = Double(visualModel.userYMax) else {
            return getSelectedReadings().count != 0 ? queryYMax ?? 0.0 : 0.0
        }
        return yMax
    }
    
    public func setYMinAndMax(yMin: Double, yMax: Double) {
        queryYMin = yMin >= 0.0 ? yMin * 0.9 : (yMin + yMin * 0.1)
        queryYMax = yMax >= 0.0 ? yMax * 1.1 : (yMax - yMax * 0.1)
    }
}


struct GraphPropertyUserDefaultModel: Codable {
    var selectedProperty: String?
    var supportedPropertyValues: [String: [String]]?
    var selectedReadings: [String]
    var graphSelectionState: GraphVisualStateInfo
    var liveInterval: Double = 60.0
    var shouldFilterByTimestamp: Bool = false
    var startTimestamp: Date = Date()
    var endTimestamp: Date = Date()
    var shouldFilterByYAxisRange: Bool = false
    var userYMin: String = "-10.0"
    var userYMax: String = "10.0"

}


@MainActor class GraphPropertyVariableModel: ObservableObject {
    public var supportedProperty: [String] = []
    public var supportedReadings: [DataValueOptionInformation] = []
    public var propertyDict = [String: [DataValueOptionInformation]]()
    public var selectedProperty: String?
}

@MainActor class GraphPropertyVisualModel: ObservableObject {
    var minY: String = "-10.0"
    var maxY: String = "10.0"

    var graphState: GraphVisualStateInfo = .live
    var liveInterval: Double = 60.0

    var shouldFilterByTimestamp: Bool = false
    var startTimestamp: Date = Date()
    var endTimestamp: Date = Date()

    var shouldFilterByYAxisRange: Bool = false
    var userYMin: String = "-10.0"
    var userYMax: String = "10.0"
}

enum GraphVisualStateInfo: String, Codable, CaseIterable, Identifiable {
    case live = "live"
    case parameterized = "parameterized"

    var id: String { self.rawValue }
}


@MainActor class DataValueOptionInformation: ObservableObject {
    var value: String
    @Published var isChecked: Bool

    init(value: String, isChecked: Bool = false) {
        self.value = value
        self.isChecked = isChecked
    }
}
