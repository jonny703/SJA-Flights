//
//  DepartureLocationController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class AirportsController: AdminBaseController {
    
    let cellId = "cellId"
    
    var publishMode: PublishMode?
    
    var publishDelegate: PublishControllerDelegate?
    var fromWhereController: FromWhereController?
    var pickedAirportIndex: Int?
    var emptyLeg: EmptyLeg?
    var pickedAirports = [PickedAirport]()
    var filteredPickedAirports = [PickedAirport]()
    var matchedAirports = [PickedAirport]()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "ICAO, IATA, Name"
        bar.searchBarStyle = .default
        bar.backgroundColor = StyleGuideManager.mainBackgroundColor
        bar.isTranslucent = false
        bar.backgroundImage = UIImage()
        bar.barTintColor = StyleGuideManager.mainBackgroundColor
        bar.tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.systemFont(ofSize: 30)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
        let textFieldInsideSearchBar = bar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        textFieldInsideSearchBar?.backgroundColor = StyleGuideManager.mainBackgroundColor
        bar.delegate = self
        
        return bar
    }()
    
    let airportsLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent departure airports:"
        label.textColor = .lightGray
        return label
    }()
    
    lazy var tableView: UITableView = {
        
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        return tv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAirports()
    }
    
    override func setupViews() {
        
        super.setupViews()
        
        self.titleLabel.text = "Departing from"
        
        setupSearchBar()
        setupTableView()
    }
    
    func fetchAirports() {
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
        
        let matchedQuery = "SELECT b.id, b.name, b.icao, b.iata, b.city, b.country FROM aircraft_departure_airport a INNER JOIN airports b ON a.airport_id=b.id where a.aircraft_id=\(aircraftId)"
        
        if let airports = SCSQLite.selectRowSQL(matchedQuery) as? [[String: Any]] {
            for airportDic in airports {
                
                guard let pickedAirport = self.handleGetPickedAirports(FromAirportDictionary: airportDic) else { return }
                
                self.matchedAirports.append(pickedAirport)
            }
        }
        
        filteredPickedAirports = matchedAirports
        
        for index in 0..<filteredPickedAirports.count {
            let pickedAirport = filteredPickedAirports[index]
            
            if let emptyLegAirport = self.emptyLeg?.departureAirport {
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
    
    func handleGetPickedAirports(FromAirportDictionary dictionary: [String: Any]) -> PickedAirport? {
        
        let id = dictionary["id"] as? Int
        let name = dictionary["name"] as? String
        let city = dictionary["city"] as? String
        let country = dictionary["country"] as? String
        let icao = dictionary["icao"] as? String
        let iata = dictionary["iata"] as? String
        
        let airport = getDecodedAirport(FromAirport: Airport(id: id, name: name, icao: icao, iata: iata, city: city, country: country))
        
        let pickedAirport = PickedAirport(isPicked: false, airport: airport)
        return pickedAirport
    }
    
    override func handleNext() {
        
        guard let index = self.pickedAirportIndex else {
            self.showJHTAlerttOkayWithIcon(message: "Please select airport")
            return
        }
        
        self.handleInsertNewAirportToDB(ByIndex: index)
        
        let pickedAirport = filteredPickedAirports[index]
        self.emptyLeg?.departureAirport = pickedAirport.airport
        
        if self.fromWhereController == .publish {
            if let airport = self.emptyLeg?.departureAirport {
                self.publishDelegate?.resetDepartureAirport(airport)
                self.handleDismissController()
            }
        } else {
            let calendarController = CalendarController()
            calendarController.emptyLeg = self.emptyLeg
            calendarController.publishMode = self.publishMode
            navigationController?.pushViewController(calendarController, animated: true)
        }
    }
    
    func handleInsertNewAirportToDB(ByIndex index: Int) {
        
        guard let aircraftId = self.emptyLeg?.aircraft?.id, let pickedAirportId = filteredPickedAirports[index].airport?.id else { return }
        
        for pickedAirport in matchedAirports {
            if let airportId = pickedAirport.airport?.id, airportId == pickedAirportId {
                return
            }
        }
        
        let dictionary = ["aircraft_id": aircraftId, "airport_id": pickedAirportId] as [String: Any]
        let success = SQLiteHelper.insert(inTable: "aircraft_departure_airport", params: dictionary)
        
        print("insert airport: ", success)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

//MARK: handle search
extension AirportsController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.filteredPickedAirports = self.matchedAirports
            
            for index in 0..<self.matchedAirports.count {
                
                if let picked = self.matchedAirports[index].isPicked, picked == true {
                    self.pickedAirportIndex = index
                }
            }
            
        } else {
            
            if searchText.count > 0 {
                
                self.pickedAirportIndex = nil
                
                self.filteredPickedAirports = self.pickedAirports.filter {
                    pickedAirport in
                    
                    guard let name = pickedAirport.airport?.name, let icao = pickedAirport.airport?.icao, let iata = pickedAirport.airport?.iata else { return false }
                    return (name.lowercased().contains(searchText.lowercased()) || icao.lowercased().contains(searchText.lowercased()) || iata.lowercased().contains(searchText.lowercased()))
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
}


//MARK: handle table view
extension AirportsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPickedAirports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AirportCell
        cell.airportsController = self
        let pickedAirport = filteredPickedAirports[indexPath.row]
        cell.pickedAirport = pickedAirport
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)
        if let index = self.pickedAirportIndex {
            
            self.filteredPickedAirports[index].isPicked = false
            
            let pickedIndexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [pickedIndexPath], with: .fade)
        }
        
        self.filteredPickedAirports[indexPath.row].isPicked = true
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        self.pickedAirportIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension AirportsController {
    
    fileprivate func setupTableView() {
        
        tableView.register(AirportCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        _ = tableView.anchor(airportsLabel.bottomAnchor, left: lineView.leftAnchor, bottom: bottomLineView.topAnchor, right: lineView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    fileprivate func setupSearchBar() {
        
        view.addSubview(searchBar)
        
        _ = searchBar.anchor(lineView.bottomAnchor, left: lineView.leftAnchor, bottom: nil, right: lineView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        let searchBottomLineView = UIView()
        searchBottomLineView.backgroundColor = .lightGray
        
        view.addSubview(searchBottomLineView)
        _ = searchBottomLineView.anchor(searchBar.bottomAnchor, left: lineView.leftAnchor, bottom: nil, right: lineView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        view.addSubview(airportsLabel)
        _ = airportsLabel.anchor(searchBottomLineView.bottomAnchor, left: lineView.leftAnchor, bottom: nil, right: lineView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
    }
    
}















