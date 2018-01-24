//
//  Day.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation

struct NextDay {
    var day: String?
    var date: String?
    var realDate: Date?
}

struct Days {
    var today: Date?
    var tomorrow: NextDay?
    var theDayAfterTomorrw: NextDay?
}
