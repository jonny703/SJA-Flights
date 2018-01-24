//
//  DateTime.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation

struct DateTime: Decodable {
    var date: String?
    var dateWithYear: String?
    var time: Time?
    var flexibility: String?
    var comingDays: Int?
}

struct Time: Decodable {
    var hour: String?
    var minutes: String?
}
