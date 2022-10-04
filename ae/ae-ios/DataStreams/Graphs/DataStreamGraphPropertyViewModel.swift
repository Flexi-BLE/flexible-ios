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
    @Published var shouldReloadGraphData = false
    
    @Published var lastReceivedTimeRecord: Date?

    private var queryYMin: Double?
    private var queryYMax: Double?

    init(dataStream: FXBDataStream) {
        self._dataStream = dataStream
        self._configName = dataStream.name
        parseReadingsFromStream()
        Task {
            await parseCurrentPropertyFromStream()
//            await getDistinctPropertyValuesCaptured()
        }
    }
    
    
    public func parseCurrentPropertyFromStream() async {
        for dv in _dataStream.dataValues {
            if dv.variableType == .tag {
                if !variableModel.supportedProperty.contains(dv.name) {
                    variableModel.supportedProperty.append(dv.name)
                    variableModel.selectedProperty = dv.name
                }
                
                if let valueOptions = dv.valueOptions {
                    variableModel.propertyDict[dv.name] = valueOptions.map{ DataValueOptionInformation(value: $0) }
                } else {
                    guard let sqlResult = await fxb.read.getDistinctValuesForColumn(for: dv.name, table_name: _configName) else {
                        return
                    }
                    DispatchQueue.main.async { [self] in
                        variableModel.propertyDict[dv.name] = sqlResult.map { DataValueOptionInformation(value: $0) }
                    }
                }
            }
        }
    }

    private func parseReadingsFromStream() {
        let dataValues = _dataStream.dataValues
        for dv in dataValues {
            if dv.variableType == .value {
                variableModel.supportedReadings.append(DataValueOptionInformation(value: dv.name))
            }
        }
    }
    
    private func getDistinctPropertyValuesCaptured() async {
        guard !variableModel.supportedProperty.isEmpty else {
//            checkPreviousStoredConfiguration()
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
//                checkPreviousStoredConfiguration()
            }
        }
    }

    private func checkPreviousStoredConfiguration() {
        do {
            variableModel = try UserDefaults.standard.getCustomObject(forKey: "\(_configName)_variable_model")
            visualModel = try UserDefaults.standard.getCustomObject(forKey: "\(_configName)_visual_model")
            shouldReloadGraphData = true
        } catch {
            createDefaultConfigurationForGraph()
            shouldReloadGraphData = true
        }
    }
        
    private func createDefaultConfigurationForGraph() {
        visualModel.graphState = .live
        if let property = variableModel.selectedProperty, let values = variableModel.propertyDict[property] {
            for eachValue in values {
                eachValue.isChecked = true
            }
        }
        if let checkedReading = variableModel.supportedReadings.first {
            checkedReading.isChecked = true
        }
    }
    
    public func saveSelectedConfigurationForGraph() {
        do {
            try UserDefaults.standard.setCustomObject(variableModel, forKey: "\(_configName)_variable_model")
            try UserDefaults.standard.setCustomObject(visualModel, forKey: "\(_configName)_visual_model")
        } catch {
            print("Error saving configuration")
        }
    }
    
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
            if let val = variableModel.propertyDict[key] {
                let filtered = val.filter { $0.isChecked == true }
                return filtered.map { $0.value }
            }
        }
        return nil
    }
    
    public func getSelectedReadings() -> [String] {
        let checkedVal = variableModel.supportedReadings.filter{ $0.isChecked }
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
    
    public func getYAxisRange() -> ClosedRange<Double> {
        let min = getYMin()
        let max = getYMax()
        guard max > min else {
            return 0.0...0.0
        }
        return min...max
    }
    
    public func getXAxisRange() -> ClosedRange<Date> {
//        if !visualModel.shouldFilterByTimestamp && visualModel.graphState == .live {
//            visualModel.endTimestamp = Date.now
//            visualModel.startTimestamp = visualModel.endTimestamp.getEarlierDateBySeconds(interval: Int(visualModel.liveInterval))
//        }
        return visualModel.startTimestamp...visualModel.endTimestamp
    }
    
    public func setYMinAndMax(yMin: Double, yMax: Double) {
        queryYMin = yMin >= 0.0 ? yMin * 0.95 : (yMin + yMin * 0.1)
        queryYMax = yMax >= 0.0 ? yMax * 1.05 : (yMax - yMax * 0.1)
    }
}

@MainActor class GraphPropertyVariableModel: Codable, ObservableObject {
    public var supportedProperty: [String] = []
    public var supportedReadings: [DataValueOptionInformation] = []
    public var propertyDict = [String: [DataValueOptionInformation]]()
    public var selectedProperty: String?
    
    
    private enum CodingKeys : String, CodingKey {
        case supportedProperty = "supportedProperty"
        case supportedReadings = "supportedReadings"
        case propertyDict = "propertyDict"
        case selectedProperty = "selectedProperty"
    }

    init() { }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.supportedProperty = try container.decodeIfPresent([String].self, forKey: .supportedProperty) ?? []
        self.supportedReadings = try container.decode([DataValueOptionInformation].self, forKey: .supportedReadings)
        self.propertyDict = try container.decode([String: [DataValueOptionInformation]].self, forKey: .propertyDict)
        self.selectedProperty = try container.decodeIfPresent(String.self, forKey: .selectedProperty)

    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(supportedProperty, forKey: .supportedProperty)
        try container.encode(supportedReadings, forKey: .supportedReadings)
        try container.encode(propertyDict, forKey: .propertyDict)
        try container.encode(selectedProperty, forKey: .selectedProperty)
    }
    
}

@MainActor class GraphPropertyVisualModel: Codable, ObservableObject {
    
    var minY: String = "-10.0"
    var maxY: String = "10.0"

    @Published var graphState: GraphVisualStateInfo = .live
    @Published var liveInterval: Double = 60.0

    @Published var shouldFilterByTimestamp: Bool = false
    @Published var startTimestamp: Date = Date()
    @Published var endTimestamp: Date = Date()

    @Published var shouldFilterByYAxisRange: Bool = false
    @Published var userYMin: String = "-10.0"
    @Published var userYMax: String = "10.0"
    
    private enum CodingKeys : String, CodingKey {
        case graphState = "graphState"
        case liveInterval = "liveInterval"
        case shouldFilterByYAxisRange = "shouldFilterByYAxisRange"
        case userYMin = "userYMin"
        case userYMax = "userYMax"
        case shouldFilterByTimestamp = "shouldFilterByTimestamp"
        case startTimestamp = "startTimestamp"
        case endTimestamp = "endTimestamp"
        case minY = "minY"
        case maxY = "maxY"
    }
    
    init() { }

    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.graphState = try container.decode(GraphVisualStateInfo.self, forKey: .graphState)
        self.liveInterval = try container.decode(Double.self, forKey: .liveInterval)
        self.shouldFilterByYAxisRange = try container.decode(Bool.self, forKey: .shouldFilterByYAxisRange)
        self.userYMin = try container.decode(String.self, forKey: .userYMin)
        self.userYMax = try container.decode(String.self, forKey: .userYMax)
        self.shouldFilterByTimestamp = try container.decode(Bool.self, forKey: .shouldFilterByTimestamp)
        if shouldFilterByTimestamp {
            self.startTimestamp = try container.decode(Date.self, forKey: .startTimestamp)
            self.endTimestamp = try container.decode(Date.self, forKey: .endTimestamp)
        } else {
            self.startTimestamp = Date()
            self.endTimestamp = Date()
        }
        self.minY = "-10.0"
        self.maxY = "10.0"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(graphState, forKey: .graphState)
        try container.encode(liveInterval, forKey: .liveInterval)
        try container.encode(shouldFilterByYAxisRange, forKey: .shouldFilterByYAxisRange)
        try container.encode(userYMin, forKey: .userYMin)
        try container.encode(userYMax, forKey: .userYMax)
        try container.encode(shouldFilterByTimestamp, forKey: .shouldFilterByTimestamp)
//        try container.encode(startTimestamp, forKey: .startTimestamp)
//        try container.encode(endTimestamp, forKey: .endTimestamp)
//        try container.encode(minY, forKey: .minY)
//        try container.encode(maxY, forKey: .maxY)

    }
    
    func toggleStringSign(_ str: String) -> String {
        guard let val = Double(str) else { return str }
        return "\(val * -1)"
    }
    
    func toggleUserMinYSign() {
        userYMin = toggleStringSign(userYMin)
    }
    
    func toggleUserMaxYSign() {
        userYMax = toggleStringSign(userYMax)
    }
}

enum GraphVisualStateInfo: String, Codable, CaseIterable, Identifiable {
    case live = "live"
    case highlights = "highlights"
    var id: String { self.rawValue }
}


@MainActor class DataValueOptionInformation: Codable, ObservableObject {
    
    var value: String
    @Published var isChecked: Bool

    init(value: String, isChecked: Bool = false) {
        self.value = value
        self.isChecked = isChecked
    }
    
    private enum CodingKeys : String, CodingKey {
        case value = "value"
        case isChecked = "isChecked"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(isChecked, forKey: .isChecked)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(String.self, forKey: .value)
        self.isChecked = try container.decode(Bool.self, forKey: .isChecked)
    }

}
