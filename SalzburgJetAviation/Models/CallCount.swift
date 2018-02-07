//
//  CallCount.swift
//  SalzburgJetAviation
//
//  Created by PAC on 2/7/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

struct CallCount: Decodable, Encodable {
    let count: Int
}

struct TotalCounts: Decodable, Encodable {
    let totalCounts: Int
}
