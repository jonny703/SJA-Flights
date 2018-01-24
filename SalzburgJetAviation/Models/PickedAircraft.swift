//
//  CheckedAircraft.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation

struct PickedAircraft {
    
    var isPicked: Bool?
    var aircraft: Aircraft?
}

struct Aircraft: Decodable {
    var id: Int?
    var name: String?
    var detail: String?
}
