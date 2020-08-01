//
//  Date Extension.swift
//  Planner
//
//  Created by oleG on 26/07/2020.
//  Copyright © 2020 Oleg Tarasenko. All rights reserved.
//

import Foundation
import UIKit

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
    
    func getOffset(from date: Date) -> NSAttributedString {
        let cal = Calendar.current
        let currentDate = cal.startOfDay(for: date)
        let otherDate = cal.startOfDay(for: self)
        let daysLeft = cal.dateComponents([.day], from: currentDate, to: otherDate).day!
        var daysLeftString: String
        var color = UIColor.darkGray
        
        switch daysLeft {
        case 0:
            daysLeftString = "Today"
        case 1:
            daysLeftString = "Tomorrow"
        case -1:
            daysLeftString = "\(daysLeft) day"
            color = .red
        case ..<0:
            daysLeftString = "\(daysLeft) days"
            color = .red
        default:
            daysLeftString = "\(daysLeft) days"
        }
        return NSAttributedString(string: daysLeftString, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    
}
