//
//  PostEmptyLeg.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/14/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation

struct PostEmptyLeg: Encodable {
    var id: Int?
    var aircraft: Int
    var departureAirport: Int
    var destinationairport: Int
    var price: Int
    var flightHours: String
    var flightMinute: String
    var departureTime: String
    var departureFlexibility: String
    var destinationTime: String
    var destinationFlexibility: String
    
}

struct EditEmptyLeg: Encodable {
    
    var id: Int
    var aircraft: Int
    var departureAirport: Int
    var destinationairport: Int
    var price: String
    var flightHours: String
    var flightMinute: String
    var departureTime: String
    var departureFlexibility: String
    var destinationTime: String
    var destinationFlexibility: String
    
}
