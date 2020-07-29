//
//  Date Extension.swift
//  Planner
//
//  Created by oleG on 26/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import Foundation

extension Date {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var today: Date {
        return shiftDay(by: 0)
    }
    
    func shiftDay(by days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? Date().today
    }
    
    func getOffset(from date: Date) -> Int {
        let cal = Calendar.current
        let currentDate = cal.startOfDay(for: date)
        let otherDate = cal.startOfDay(for: self)
        
        return cal.dateComponents([.day], from: currentDate, to: otherDate).day!
    }
}
