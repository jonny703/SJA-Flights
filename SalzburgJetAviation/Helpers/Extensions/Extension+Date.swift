//
//  Extension+Date.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation

extension Date {
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var theDayAfterTomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 2, to: noon)!
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    func days(from date: Date) -> Int {
        
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
        
    }
}
