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
    
    func getDetailedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func SQLiteDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        return formatter.string(from: self)
    }
    
    func getEarlierDateBySeconds(interval: Int) -> Date {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: .second, value: -interval, to: self) else {
            return Date()
        }
        return date
    }

}
