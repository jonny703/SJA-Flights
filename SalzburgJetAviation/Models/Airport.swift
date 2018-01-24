//
//  Airport.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation

struct Airport: Decodable, Encodable {
    
    
    var id: Int?
    var name: String?
    var icao: String?
    var iata: String?
    var city: String?
    var country: String?
    
//    init?(dictionary: [String: Any]) {
//        
//        self.id = dictionary["id"] as? Int
//        self.name = dictionary["name"] as? String
//        self.city = dictionary["city"] as? String
//        self.country = dictionary["country"] as? String
//    }
    
    var dictionaryRepresention: [String: Any] {
        return [:]
    }
}

struct PickedAirport {
    
    var isPicked: Bool?
    var airport: Airport?
}
