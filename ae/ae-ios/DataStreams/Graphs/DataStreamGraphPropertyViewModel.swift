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
    private var dataStream: FXBDataStream
    private var configName: String
    @Published public var supportedProperty: [String]? = []
    @Published public var supportedReading: DataValueOptionsListModel = DataValueOptionsListModel(withValues: [])
    
    @Published public var selectedProperty: String? = nil
    @Published public var propertyDict = [String: DataValueOptionsListModel]()
    
    @Published public var shouldFilterByTimestamp: Bool = false
    @Published public var startTimestamp: Date = Date()
    @Published public var endTimestamp: Date = Date()
    
    @Published public var shouldFilterByYAxisRange: Bool = false
    @Published public var userYMin: String = "-10.0"
    @Published public var userYMax: String = "10.0"
    private var queryYMin: Double?
    private var queryYMax: Double?
    
    init(_ dataStream: FXBDataStream) {
        self.dataStream = dataStream
        self.configName = dataStream.name
        filterPropertyAndReadings(from: dataStream.dataValues)
        Task {
            await getDistinctPropertyValues()
        }
    }
    
    private func filterPropertyAndReadings(from dataConfig: [FXBDataValueDefinition]) {
        for dc in dataConfig {
            if dc.variableType == .tag {
                supportedProperty?.append(dc.name)
                selectedProperty = dc.name
            } else if dc.variableType == .value {
                supportedReading.values.append(DataValueOptionInformation(value: dc.name))
            }
        }
    }
    
    private func getDistinctPropertyValues() async {
        guard let property = supportedProperty else {
            return
        }
        for eachProperty in property {
            var distinctValues:[DataValueOptionInformation] = []
            let result = await fxb.read.getDistinctValuesForColumn(for: eachProperty, table_name: configName)
            guard let values = result else {
                return
            }
            DispatchQueue.main.async {
                for eachValue in values {
                    distinctValues.append(DataValueOptionInformation(value: eachValue))
                }
                self.propertyDict[eachProperty] = DataValueOptionsListModel(withValues: distinctValues)
            }
        }
    }
    
    public func checkDependencyOfReadingsOnProperty(for readings: [String], selectedProperty: String?) -> Bool {
        for dsc in dataStream.dataValues {
            if readings.contains(dsc.name), selectedProperty != nil, let props = selectedProperty, !(dsc.dependsOn?.contains(props) != nil) {
                return false
            }
        }
        return true
    }
    
    public func getSelectedValuesFromProperty(forKey: String?) -> [String]? {
        if let key = forKey, propertyDict[key] != nil {
            let values = propertyDict[key]
            if let val = values {
                let filtered = val.values.filter ({ $0.isChecked == true })
                return filtered.map { $0.value }
            }
        }
        return nil
    }
    
    public func getSelectedReadings() -> [String] {
        let checkedVal = supportedReading.values.filter({ $0.isChecked })
        return checkedVal.map { $0.value }
    }
    
    public func getYMin() -> Double {
        guard shouldFilterByYAxisRange, let yMin = Double(userYMin) else {
            return getSelectedReadings().count != 0 ? queryYMin ?? 0.0 : 0.0
        }
        return yMin
    }
    
    public func getYMax() -> Double {
        guard shouldFilterByYAxisRange, let yMax = Double(userYMax) else {
            return getSelectedReadings().count != 0 ? queryYMax ?? 0.0 : 0.0
        }
        return yMax
    }
    
    public func setYMinAndMax(yMin: Double, yMax: Double) {
        queryYMin = yMin >= 0.0 ? yMin * 0.9 : (yMin + yMin * 0.1)
        queryYMax = yMax >= 0.0 ? yMax * 1.1 : (yMax - yMax * 0.1)
    }
    
    public func getCurrentConfigLabel() -> String {
        var currntConfig = "\(selectedProperty ?? "") "
        if let selectedValuesForProperty = getSelectedValuesFromProperty(forKey: selectedProperty) {
            currntConfig.append(" - [ ")
            for eachValue in selectedValuesForProperty {
                currntConfig.append("\(eachValue) ")
            }
            currntConfig.append("]")
        }
        let selectedValues = getSelectedReadings()
        if selectedValues.isEmpty {
            return currntConfig
        }
        currntConfig.append(" with values: ")
        for eachVal in selectedValues {
            currntConfig.append("\(eachVal) ")
        }
        return currntConfig
    }
}

@MainActor class DataValueOptionInformation: ObservableObject, Identifiable {
    var value: String
    @Published var isChecked: Bool
    
    init(value: String, isChecked: Bool = false) {
        self.value = value
        self.isChecked = isChecked
    }
}

@MainActor class DataValueOptionsListModel: ObservableObject {
    @Published var values : [DataValueOptionInformation]
    init(withValues: [DataValueOptionInformation]) {
        self.values = withValues
    }
}

struct DataStreamGraphPoint {
    var mark: String
    var data: [(ts: Date, val: Double)]
}
