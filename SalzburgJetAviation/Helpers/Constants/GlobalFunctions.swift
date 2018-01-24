//
//  GlobalFunctions.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/16/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation

func getEncodedAirport(FromAirport airport: Airport) -> Airport {
    
    let name = airport.name?.toBase64()
    let city = airport.city?.toBase64()
    let country = airport.country?.toBase64()
    let icao = airport.icao?.toBase64()
    let iata = airport.iata?.toBase64()
    
    let encodedAirport = Airport(id: airport.id, name: name, icao: icao, iata: iata, city: city, country: country)
    
    return encodedAirport
}

func getDecodedAirport(FromAirport airport: Airport) -> Airport {
    
    let name = airport.name?.fromBase64()
    let city = airport.city?.fromBase64()
    let country = airport.country?.fromBase64()
    let icao = airport.icao?.fromBase64()
    let iata = airport.iata?.fromBase64()
    
    let encodedAirport = Airport(id: airport.id, name: name, icao: icao, iata: iata, city: city, country: country)
    
    return encodedAirport
    
}
