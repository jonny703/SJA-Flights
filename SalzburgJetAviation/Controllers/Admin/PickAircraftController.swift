//
//  PickAircraftController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class PickAircraftController: AdminBaseController {
    
    let cellId = "cellId"
    
    var publishMode: PublishMode?
    
    var publishDelegate: PublishControllerDelegate?
    var fromWhereController: FromWhereController?
    var pickedAircraftIndex: Int?
    var emptyLeg: EmptyLeg?
    
    var pickedAircrafts = [PickedAircraft]()
    
    
    
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
        
        fetchAircrafts()
    }
    
    override func setupViews() {
        super.setupViews()
        self.bottomLineView.isHidden = true
        self.titleLabel.text = "Pick Aircraft"
        
        setupTableView()
    }
    
    override func handleNext() {
        
        guard let index = self.pickedAircraftIndex else {
            self.showJHTAlerttOkayWithIcon(message: "Please select aircraft")
            return
        }
        
        let pickedAircraft = pickedAircrafts[index]
        
        if self.publishMode == .create {
            self.emptyLeg = EmptyLeg(id: nil, aircraft: pickedAircraft.aircraft, departureAirport: nil, departureDateTime: nil, destinationAirport: nil, destinationDateTime: nil, estimatedFlightTime: nil, price: nil)
        } else {
            self.emptyLeg?.aircraft = pickedAircraft.aircraft
        }
        
        if self.fromWhereController == .publish {
            if let aircraft = self.emptyLeg?.aircraft {
                self.publishDelegate?.resetAircraft(aircraft)
                self.handleDismissController()
            }
        } else {
            let departureLocationController = AirportsController()
            departureLocationController.emptyLeg = self.emptyLeg
            departureLocationController.publishMode = self.publishMode
            navigationController?.pushViewController(departureLocationController, animated: true)
        }
    }
    
    func fetchAircrafts() {
        
        APIService.sharedInstance.fetchAircraft { (aircrafts: [Aircraft]) in
            
            for index in 0..<aircrafts.count {
                
                var isPicked = false
                let aircraft = aircrafts[index]
                
                if let emptyLegAircraft = self.emptyLeg?.aircraft {
                    if emptyLegAircraft.id == aircraft.id {
                        isPicked = true
                        self.pickedAircraftIndex = index
                    }
                }
                
                let pickedAircraft = PickedAircraft(isPicked: isPicked, aircraft: aircraft)
                self.pickedAircrafts.append(pickedAircraft)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: handle table view
extension PickAircraftController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickedAircrafts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PickAircraftCell
        
        cell.pickAircraftController = self
        
        let pickedAircraft = pickedAircrafts[indexPath.row]
        cell.pickedAircraft = pickedAircraft
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let index = self.pickedAircraftIndex {
            
            self.pickedAircrafts[index].isPicked = false
            
            let pickedIndexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [pickedIndexPath], with: .fade)
        }
        
        self.pickedAircrafts[indexPath.row].isPicked = true
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        self.pickedAircraftIndex = indexPath.row
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension PickAircraftController {
    
    
    
    fileprivate func setupTableView() {
        
        tableView.register(PickAircraftCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        _ = tableView.anchor(lineView.bottomAnchor, left: lineView.leftAnchor, bottom: checkButton.topAnchor, right: lineView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
}
