//
//  PublishController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import SVProgressHUD
import OneSignal

enum FromWhereController {
    case general
    case publish
}

enum PublishMode {
    case create
    case edit
}

protocol PublishControllerDelegate {
    func resetAircraft(_ aircraft: Aircraft)
    func resetDepartureAirport(_ airport: Airport)
    func resetDepartureDateTime(_ dateTime: DateTime)
    func resetDestinationAirport(_ airport: Airport)
    func resetEstimatedTime(_ estimatedTime: Time)
    func resetPrice(_ price: String)
}

class PublishController: AdminBaseController {
    
    let aircraftPublishCellId = "generalPublishCellId"
    let airportPublishCellId = "airportPublishCellId"
    let dateTimePublishCellId = "dateTimePublishCellId"
    let estimatedTimePublishCellId = "estimatedTimePublishCellId"
    let pricePublishCellId = "pricePublishCellId"
    
    var emptyLeg: EmptyLeg?
    var publishMode: PublishMode?
    
    let publishButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Publish Empty Leg", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.backgroundColor = StyleGuideManager.mainYellowColor
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handlePublish), for: .touchUpInside)
        return button
        
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
    }
    
    override func setupViews() {
        super.setupViews()
        
        checkButton.isHidden = true
        titleLabel.text = "Review and Publish"
        
        setupPublishButton()
        setupTableView()
    }
}

//hanlde publish controller delegate
extension PublishController: PublishControllerDelegate {
    func resetEstimatedTime(_ estimatedTime: Time) {
        self.emptyLeg?.estimatedFlightTime = estimatedTime
        reloadTableViewRow(4)
    }
    
    func resetPrice(_ price: String) {
        self.emptyLeg?.price = price
        reloadTableViewRow(5)
    }
    
    
    func resetAircraft(_ aircraft: Aircraft) {
        self.emptyLeg?.aircraft = aircraft
        reloadTableViewRow(0)
    }
    
    func resetDepartureAirport(_ airport: Airport) {
        self.emptyLeg?.departureAirport = airport
        reloadTableViewRow(1)
    }
    
    func resetDepartureDateTime(_ dateTime: DateTime) {
        self.emptyLeg?.departureDateTime = dateTime
        reloadTableViewRow(2)
    }
    
    func resetDestinationAirport(_ airport: Airport) {
        self.emptyLeg?.destinationAirport = airport
        reloadTableViewRow(3)
    }
    
    private func reloadTableViewRow(_ row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .left)
    }
}

//MARK: handle table view
extension PublishController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: airportPublishCellId, for: indexPath) as! AirportPublishCell
            cell.whereAirPort = .departure
            if let airport = emptyLeg?.departureAirport {
                cell.airport = airport
            }
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: airportPublishCellId, for: indexPath) as! AirportPublishCell
            cell.whereAirPort = .destination
            if let airport = emptyLeg?.destinationAirport {
                cell.airport = airport
            }
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: dateTimePublishCellId, for: indexPath) as! DateTimePublishCell
            cell.whatDateTime = .departure
            if let dateTime = emptyLeg?.departureDateTime {
                cell.dateTime = dateTime
            }
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: estimatedTimePublishCellId, for: indexPath) as! EstimatedTimePublishCell
            
            if let estimatedTime = emptyLeg?.estimatedFlightTime {
                cell.estimatedTime = estimatedTime
            }
            
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: pricePublishCellId, for: indexPath) as! PricePublishCell
            
            if let price = emptyLeg?.price {
                cell.price = price
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: aircraftPublishCellId, for: indexPath) as! AircraftPublishCell
            
            if let aircraft = emptyLeg?.aircraft {
                cell.aircraft = aircraft
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let aircraftController = PickAircraftController()
            aircraftController.emptyLeg = self.emptyLeg
            aircraftController.fromWhereController = .publish
            aircraftController.publishDelegate = self
            navigationController?.pushViewController(aircraftController, animated: true)
        } else if indexPath.row == 1 {
            let departureController = AirportsController()
            departureController.emptyLeg = self.emptyLeg
            departureController.fromWhereController = .publish
            departureController.publishDelegate = self
            navigationController?.pushViewController(departureController, animated: true)
        } else if indexPath.row == 2 {
            let calendarController = CalendarController()
            calendarController.emptyLeg = self.emptyLeg
            calendarController.fromWhereController = .publish
            calendarController.publishDelegate = self
            navigationController?.pushViewController(calendarController, animated: true)
        } else if indexPath.row == 4 {
            let estimatedTimeController = EstimatedTimeController()
            estimatedTimeController.emptyLeg = self.emptyLeg
            estimatedTimeController.fromWhereController = .publish
            estimatedTimeController.publishDelegate = self
            navigationController?.pushViewController(estimatedTimeController, animated: true)
        } else if indexPath.row == 5 {
            let priceController = PriceController()
            priceController.emptyLeg = self.emptyLeg
            priceController.fromWhereController = .publish
            priceController.publishDelegate = self
            navigationController?.pushViewController(priceController, animated: true)
        } else {
            let destinationController = ArrivingAirportController()
            destinationController.emptyLeg = self.emptyLeg
            destinationController.fromWhereController = .publish
            destinationController.publishDelegate = self
            navigationController?.pushViewController(destinationController, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 140
        } else if indexPath.row == 1 || indexPath.row == 3 {
            return 120
        } else {
            return 80
        }
        
    }
}



//MARK: handle publish
extension PublishController {
    
    @objc fileprivate func handlePublish() {
        
//        handleSendPushNotification()
//        
        handleCreateEmptyLeg()
    }
    
    private func handleDismissToRoot() {
        navigationController?.popToRootViewController(animated: true)
        
        NotificationCenter.default.post(name: .HandlePoppingToRootNav, object: nil)
    }
    
    private func handleSendPushNotification() {
        
        if let _ = self.emptyLeg?.id { return }
        guard let departingCity = emptyLeg?.departureAirport?.city, let destinationCity = emptyLeg?.destinationAirport?.city, let departingDate = emptyLeg?.departureDateTime?.date else { return }
        
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        guard let _ = status.subscriptionStatus.pushToken else { return }
        
        let message = departingCity.trimmingCharacters(in: .whitespacesAndNewlines) + " - " + destinationCity.trimmingCharacters(in: .whitespacesAndNewlines) + ", " + departingDate
        
        guard let url = URL(string: "https://onesignal.com/api/v1/notifications") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("Basic OGU0ZGRlNjYtMDgyNS00ZjVhLTg3NzMtZWNjOTA3MDcyZjVm", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let notificationContent = NotificationContent(app_id: "90912c11-ad1c-49eb-9773-15b21703e4ec", included_segments: ["All"], contents: ["en": message], headings: ["en": "New empty leg available"], ios_badgeType: "Increase", ios_badgeCount: 1)
        
        do {
            let jsonBody = try JSONEncoder().encode(notificationContent)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing fetch aircraft", jsonError)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let _ = error {
                return
            }
            
            guard let data = data else { return }
            
            let jsonString = String(data: data, encoding: .utf8)
            
            print("jsonPush: ", jsonString ?? "")
        }
        
        task.resume()
    }
    
    private func handleCreateEmptyLeg() {
        
        guard let aircraft = self.emptyLeg?.aircraft?.id, let departureAirport = emptyLeg?.departureAirport?.id, let destinationAirport = emptyLeg?.destinationAirport?.id, let flightHours = emptyLeg?.estimatedFlightTime?.hour, let flightMinute = emptyLeg?.estimatedFlightTime?.minutes, let departureDate = emptyLeg?.departureDateTime?.dateWithYear, let depatureHour = emptyLeg?.departureDateTime?.time?.hour, let depatureMinutes = emptyLeg?.departureDateTime?.time?.minutes, let flexibility = emptyLeg?.departureDateTime?.flexibility, let price = emptyLeg?.price else { return }
        
        guard let departureTime = self.handleGetDateTimeFormatFrom(date: departureDate, hour: depatureHour, minutes: depatureMinutes) else { return }
        guard let destinationTime = self.handleGetDestinationTime(FromDepartureTime: departureTime, estimatedFlightHours: flightHours, estimatedFlightMinutes: flightMinute) else { return }
        guard let priceNumber = Int(price), let _ = Int(flightHours), let _ = Int(flightMinute) else { return }
            
        let postEmptyLeg = PostEmptyLeg(id: self.emptyLeg?.id, aircraft: aircraft, departureAirport: departureAirport, destinationairport: destinationAirport, price: priceNumber, flightHours: flightHours, flightMinute: flightMinute , departureTime: departureTime, departureFlexibility: flexibility, destinationTime: destinationTime, destinationFlexibility: flexibility)
        
        var urlString: String
        
        if self.publishMode == .create {
            urlString = String(format: WebService.createEmptyLegLongUrl.rawValue, postEmptyLeg.aircraft, postEmptyLeg.departureAirport, postEmptyLeg.destinationairport, postEmptyLeg.price, postEmptyLeg.flightHours, postEmptyLeg.flightMinute, postEmptyLeg.departureTime, postEmptyLeg.departureFlexibility, postEmptyLeg.destinationTime, postEmptyLeg.destinationFlexibility)
        } else {
            guard let id = self.emptyLeg?.id else { return }
            urlString = String(format: WebService.editEmptyLegLongUrl.rawValue, id, postEmptyLeg.aircraft, postEmptyLeg.departureAirport, postEmptyLeg.destinationairport, postEmptyLeg.price, postEmptyLeg.flightHours, postEmptyLeg.flightMinute, postEmptyLeg.departureTime, postEmptyLeg.departureFlexibility, postEmptyLeg.destinationTime, postEmptyLeg.destinationFlexibility)
        }
        
        print("url: ", urlString)
        
        guard let urlStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let url = URL(string: urlStr) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let username = UserDefaults.standard.getUsername(), let password = UserDefaults.standard.getPassword() else { return }
        
        let base64String = "Basic " + (username + ":" + password).toBase64()
        
        request.addValue(base64String, forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
//        do {
//            let jsonBody = try JSONEncoder().encode(postEmptyLeg)
//            request.httpBody = jsonBody
//            print("jsonBody:", jsonBody)
//        } catch let jsonError {
//            print("Error serializing encoding empty leg", jsonError)
//        }
        
        print("post:", postEmptyLeg)
        SVProgressHUD.show()
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                self.showErrorMessage()
                print("Error for publish: ", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                self.showErrorMessage()
                return }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            if jsonString == "\"success\"" {
                
                if self.publishMode == .create {
                    self.handleSendPushNotification()
                }
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.handleDismissToRoot()
                }
                
            } else {
                self.showErrorMessage()
            }
        }
        
        task.resume()
    }
    
    private func handleGetDestinationTime(FromDepartureTime departureTime: String, estimatedFlightHours: String, estimatedFlightMinutes: String) -> String? {
        guard let hours = Int(estimatedFlightHours), let minutes = Int(estimatedFlightMinutes) else { return nil }
        let estimatedTimeInterval = (hours * 60 + minutes) * 60
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let departureTime = formatter.date(from: departureTime) else { return nil }
        
        let destinationTime = Date(timeInterval: TimeInterval(estimatedTimeInterval), since: departureTime)
        let destinationTimeString = formatter.string(from: destinationTime)
        
        return destinationTimeString
    }
    
    private func handleGetDateTimeFormatFrom(date: String, hour: String, minutes: String) -> String? {
        
        let oldFormatter = DateFormatter()
        let newFormatter = DateFormatter()
        
        newFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if self.publishMode == .create {
            oldFormatter.dateFormat = "d.MMM. yyyy HH:mm"
        } else {
            oldFormatter.dateFormat = "EEE, d.MMM. yyyy HH:mm"
        }
        
        
        let oldDateStr = date + " " + hour + ":" + minutes
        
        guard let oldDate = oldFormatter.date(from: oldDateStr) else { return nil }
        let newDateStr = newFormatter.string(from: oldDate)
        
        print(oldDateStr, oldDate, newDateStr)
        
        return newDateStr
    }
    
    private func showErrorMessage() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showJHTAlerttOkayWithIcon(message: "Something went wrong!\nTry again later.")
        }
    }
}

//json:  {"code":"rest_forbidden","message":"Sorry, you are not allowed to do that.","data":{"status":403}}

extension PublishController {
    
    fileprivate func setupTableView() {
        
        tableView.register(AircraftPublishCell.self, forCellReuseIdentifier: aircraftPublishCellId)
        tableView.register(AirportPublishCell.self, forCellReuseIdentifier: airportPublishCellId)
        tableView.register(DateTimePublishCell.self, forCellReuseIdentifier: dateTimePublishCellId)
        tableView.register(EstimatedTimePublishCell.self, forCellReuseIdentifier: estimatedTimePublishCellId)
        tableView.register(PricePublishCell.self, forCellReuseIdentifier: pricePublishCellId)
        
        view.addSubview(tableView)
        
        _ = tableView.anchor(lineView.bottomAnchor, left: lineView.leftAnchor, bottom: bottomLineView.topAnchor, right: lineView.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    fileprivate func setupPublishButton() {
        
        view.addSubview(publishButton)
        
        _ = publishButton.anchor(nil, left: backButton.rightAnchor, bottom: nil, right: lineView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        publishButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        
    }
    
}
