//
//  Date+Utils.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import Foundation

extension Date {
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    func getNameOfDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    func getShortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        return dateFormatter.string(from: self)
    }
    
    func getDateAndTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func getShortDateAndTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func getDetailedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func getFileNameFriendlyDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "MM_dd_YYYY__HH_mm_ss"
        return dateFormatter.string(from: self)
    }
    
    func timeSinceHumanReadable(ref: Date=Date.now) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .brief
        return formatter.string(from: self, to: ref) ?? "--"
    }
    
    func SQLiteDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        return formatter.string(from: self)
    }
    
    func getEarlierDateBySeconds(interval: Int) -> Date {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: .second, value: -interval, to: self) else {
            return Date()
        }
        return date
    }
    
    static func fromSQLString(_ str: String) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        
        return formatter.date(from: str)
    }
    
    func timeDiff(start: Date) -> String {
       let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.nanosecond]
        return formatter.string(from: start, to: self) ?? "-"
    }

}
