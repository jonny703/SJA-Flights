//
//  EmptyLeg.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation

struct EmptyLeg: Decodable {
    var id: Int?
    var aircraft: Aircraft?
    var departureAirport: Airport?
    var departureDateTime: DateTime?
    var destinationAirport: Airport?
    var destinationDateTime: DateTime?
    var estimatedFlightTime: Time?
    var price: String?
}
