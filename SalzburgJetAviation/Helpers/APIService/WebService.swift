//
//  WebService.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/14/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation

//http://sja.devserver4.com/wp-json/iosapp/v1/legcreate/?id=nil&aircraft=116&departureAirport=5934&destinationairport=5931&price=350&flightHours=00&flightMinute=30&departureTime=2017-12-15

enum WebService: String {
    
    case adminLogin = "http://sja.devserver4.com/wp-json/iosapp/v1/checkuser/"
    
    case fetchAircraft = "http://sja.devserver4.com/wp-json/iosapp/v1/airplane/"
    case fetchAirports = "http://sja.devserver4.com/wp-json/iosapp/v1/airports/"
    case fetchEmptyLegs = "http://sja.devserver4.com/wp-json/iosapp/v1/legs/"
    
    case createEmptyLeg = "http://sja.devserver4.com/wp-json/iosapp/v1/legcreate/"
    case deleteLeg = "http://sja.devserver4.com/wp-json/iosapp/v1/delete_leg/"
    
    case createEmptyLegLongUrl = "http://sja.devserver4.com/wp-json/iosapp/v1/legcreate/?id=nil&aircraft=%d&departureAirport=%d&destinationairport=%d&price=%d&flightHours=%@&flightMinute=%@&departureTime=%@&departureFlexibility=%@&destinationTime=%@&destinationFlexiblity=%@"
    case editEmptyLegLongUrl = "http://sja.devserver4.com/wp-json/iosapp/v1/legcreate/?id=%d&aircraft=%d&departureAirport=%d&destinationairport=%d&price=%d&flightHours=%@&flightMinute=%@&departureTime=%@&departureFlexibility=%@&destinationTime=%@&destinationFlexiblity=%@"
    
    
}
