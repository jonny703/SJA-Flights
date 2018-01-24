//
//  ArrivingAirportController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class ArrivingAirportController: AirportsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.airportsLabel.text = "Recent arrival airports:"
        
        titleLabel.text = "Arriving at"
    }
    
    override func fetchAirports() {
        
        SCSQLite.initWithDatabase("sdj_flights.sqlite3")
        
        let query = "SELECT * FROM airports"
        if let airports = SCSQLite.selectRowSQL(query) as? [[String: Any]] {
            for airportDic in airports {
                
                if let pickedAirport = self.handleGetPickedAirports(FromAirportDictionary: airportDic) {
                    self.pickedAirports.append(pickedAirport)
                }
            }
        }
        
        guard let aircraftId = self.emptyLeg?.aircraft?.id else { return }
        
        let matchedQuery = "SELECT b.id, b.name, b.icao, b.iata, b.city, b.country FROM aircraft_destination_airport a INNER JOIN airports b ON a.airport_id=b.id where a.aircraft_id=\(aircraftId)"
        
        if let airports = SCSQLite.selectRowSQL(matchedQuery) as? [[String: Any]] {
            for airportDic in airports {
                
                guard let pickedAirport = self.handleGetPickedAirports(FromAirportDictionary: airportDic) else { return }
                
                self.matchedAirports.append(pickedAirport)
            }
        }
        
        filteredPickedAirports = matchedAirports
        
        for index in 0..<filteredPickedAirports.count {
            let pickedAirport = filteredPickedAirports[index]
            
            if let emptyLegAirport = self.emptyLeg?.destinationAirport {
                if emptyLegAirport.id == pickedAirport.airport?.id {
                    self.pickedAirportIndex = index
                    self.filteredPickedAirports[index].isPicked = true
                }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    override func handleInsertNewAirportToDB(ByIndex index: Int) {
        
        guard let aircraftId = self.emptyLeg?.aircraft?.id, let pickedAirportId = filteredPickedAirports[index].airport?.id else { return }
        
        for pickedAirport in matchedAirports {
            if let airportId = pickedAirport.airport?.id, airportId == pickedAirportId {
                return
            }
        }
        
        let dictionary = ["aircraft_id": aircraftId, "airport_id": pickedAirportId] as [String: Any]
        let success = SQLiteHelper.insert(inTable: "aircraft_destination_airport", params: dictionary)
        print("insert airport: ", success)
    }
    
    override func handleNext() {
        
        guard let index = self.pickedAirportIndex else {
            self.showJHTAlerttOkayWithIcon(message: "Please select aircport")
            return
        }
        
        self.handleInsertNewAirportToDB(ByIndex: index)
        
        let pickedAirport = filteredPickedAirports[index]
        self.emptyLeg?.destinationAirport = pickedAirport.airport
        
        if self.fromWhereController == .publish {
            if let airport = self.emptyLeg?.destinationAirport {
                self.publishDelegate?.resetDestinationAirport(airport)
                self.handleDismissController()
            }
        } else {
            let estimatedTimeController = EstimatedTimeController()
            estimatedTimeController.emptyLeg = self.emptyLeg
            estimatedTimeController.publishMode = self.publishMode
            navigationController?.pushViewController(estimatedTimeController, animated: true)
        }
    }
    
}
