//
//  CreateEmptyLegController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import SVProgressHUD

class CreateEmptyLegController: UIViewController {
    
    let cellId = "cellId"
    
    var emptyLegs = [EmptyLeg]()
    var sortedAircraftLegs = [EmptyLeg]()
    var sortedDateLegs = [EmptyLeg]()
    
    let lineView = UIView()
    
    lazy var newLegButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.addPlus.rawValue)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setTitle("New Empty Leg", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleCreateNewLeg), for: .touchUpInside)
        return button
        
    }()
    
    lazy var menuBar: SortByMenuBar = {
        let mb = SortByMenuBar()
        mb.creatEmptyController = self
        return mb
    }()
    
    lazy var tableView: UITableView = {
        
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        return tv
        
    }()
    
    lazy var logoutView: LogoutView = {
        let view = LogoutView()
        view.backgroundColor = .clear
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleLogout))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        handleFetchEmptyLegs()
    }
    
}

//MARK: handle fetch empty legs
extension CreateEmptyLegController {
    
    fileprivate func handleFetchEmptyLegs() {
        
        APIService.sharedInstance.fetchEmptyLegs { (emptyLegs: [EmptyLeg]) in
            
            self.sortedAircraftLegs = emptyLegs
            self.sortedDateLegs = emptyLegs
            
            self.sortedAircraftLegs.sort { (leg1, leg2) -> Bool in
                
                guard let name1 = leg1.aircraft?.name, let name2 = leg2.aircraft?.name else { return false }
                
                return name1 < name2
            }
            
            let todayWithYearFormatter = DateFormatter()
            todayWithYearFormatter.dateFormat = "d.MMM. yyyy hh:mm"
            self.sortedDateLegs.sort { (leg1, leg2) -> Bool in
                
                guard let dateStr1 = leg1.departureDateTime?.dateWithYear, let dateStr2 = leg2.departureDateTime?.dateWithYear else { return false }
                guard let hour1 = leg1.departureDateTime?.time?.hour, let minutes1 = leg1.departureDateTime?.time?.minutes, let hour2 = leg2.departureDateTime?.time?.hour, let minutes2 = leg2.departureDateTime?.time?.minutes else { return false }
                guard let date1 = todayWithYearFormatter.date(from: "\(dateStr1) \(hour1):\(minutes1)"), let date2 = todayWithYearFormatter.date(from: "\(dateStr2) \(hour2):\(minutes2)") else { return false }
                
                return date1 < date2
            }
            
            self.emptyLegs = self.sortedAircraftLegs
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

//MARK: handle aircraft/date
extension CreateEmptyLegController {
    
    
    func scrollToMenuIndex(menuIndex: Int) {
        
        if menuIndex == 0 {
            emptyLegs = sortedAircraftLegs
        } else {
            emptyLegs = sortedDateLegs
        }
        
        self.tableView.reloadData()
        
    }
    
}

//MARK: handle logout, create neww empty leg
extension CreateEmptyLegController {
    
    @objc fileprivate func handleLogout() {
        
        self.showJHTAlertDefaultWithIcon(message: "Are you sure you want to log out?", firstActionTitle: "Later", secondActionTitle: "Yes") { (action) in
            UserDefaults.standard.setIsLoggedIn(value: false)
            
            self.handleDismissController()
        }
    }
    
    @objc fileprivate func handleCreateNewLeg() {
        let pickAirCraftController = PickAircraftController()
        pickAirCraftController.publishMode = .create
        navigationController?.pushViewController(pickAirCraftController, animated: true)
    }
}

//MARK: handle table view
extension CreateEmptyLegController: UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emptyLegs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmptyLegCell
        cell.delegate = self
        
        let emptyLeg = self.emptyLegs[indexPath.row]
        cell.emptyLeg = emptyLeg
        
        let removeButton = MGSwipeButton(title: "remove", backgroundColor: StyleGuideManager.mainYellowColor)
        removeButton.setTitleColor(.darkGray, for: .normal)
        let editButton = MGSwipeButton(title: "edit", backgroundColor: .clear)

        cell.rightButtons = [editButton, removeButton]
        cell.tag = indexPath.row
        cell.rightSwipeSettings.transition = .drag
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
//    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
//
//        swipeSettings.transition = .border
//
//        if direction == MGSwipeDirection.rightToLeft {
//
//            let removeButton = MGSwipeButton(title: "remove", backgroundColor: StyleGuideManager.mainYellowColor)
//            let editButton = MGSwipeButton(title: "edit", backgroundColor: .clear)
//
//            return [editButton, removeButton]
//
//        } else {
//            return nil
//        }
//
//    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {

        let indexPath = IndexPath(row: cell.tag, section: 0)

        if index == 0 {
            print("edit")

            let emptyLeg = self.emptyLegs[indexPath.row]
            let publishController = PublishController()
            publishController.emptyLeg = emptyLeg
            publishController.publishMode = .edit
            navigationController?.pushViewController(publishController, animated: true)
            
        } else {
            print("remove")
            
            self.showJHTAlertDefaultWithIcon(message: "Delete this Empty Leg?\n(All data entered will be lost)", firstActionTitle: "Cancel", secondActionTitle: "Delete Leg", action: { (action) in
                
                let emptyleg = self.emptyLegs[indexPath.row]
                
                self.handleDelete(emptyLeg: emptyleg, index: indexPath.row)
                
            })
        }

        return true
    }
}


extension CreateEmptyLegController {

    fileprivate func handleDelete(emptyLeg: EmptyLeg, index: Int) {
        
        guard let id = emptyLeg.id else { return }
        
        let urlString = WebService.deleteLeg.rawValue + String(id) + "/"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Basic c2phOnlEaSlSI2xHJTR6NmhSaygwUw==", forHTTPHeaderField: "Authorization")
        
        SVProgressHUD.show()
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                self.showErrorMessage()
                print("createError: ", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                self.showErrorMessage()
                return }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            if jsonString == "\"success\"" {
                
                self.emptyLegs.remove(at: index)
                
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                }
            } else {
                self.showErrorMessage()
            }
        }
        
        task.resume()
    }
    
    private func showErrorMessage() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showJHTAlerttOkayWithIcon(message: "Something went wrong!\nTry again later.")
        }
    }
    
    @objc fileprivate func handleDismissController() {
        
        navigationController?.popViewController(animated: true)
        
    }
}

extension CreateEmptyLegController {
    
    fileprivate func setupViews() {
        setupNewButton()
        setupBackgrounds()
        logoutViews()
        setupTableView()
    }
    
    private func logoutViews() {
        
        view.addSubview(logoutView)
        
        _ = logoutView.anchor(nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 60, heightConstant: 50)
        logoutView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        lineView.backgroundColor = .gray
        
        view.addSubview(lineView)
        _ = lineView.anchor(nil, left: view.leftAnchor, bottom: logoutView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    private func setupTableView() {
        
        tableView.register(EmptyLegCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        _ = tableView.anchor(menuBar.bottomAnchor, left: menuBar.leftAnchor, bottom: lineView.topAnchor, right: menuBar.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    private func setupNewButton() {
        view.addSubview(newLegButton)
        
        _ = newLegButton.anchor(view.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 250, heightConstant: 30)
        newLegButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupBackgrounds() {
    
        view.backgroundColor = StyleGuideManager.mainBackgroundColor
        
        let backButton = UIButton(type: .system)
        let backImage = UIImage(named: AssetName.leftArrow.rawValue)?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(handleDismissController), for: .touchUpInside)
        
        view.addSubview(backButton)
        
        _ = backButton.anchor(nil, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        backButton.centerYAnchor.constraint(equalTo: newLegButton.centerYAnchor).isActive = true
        
        view.addSubview(menuBar)
        _ = menuBar.anchor(newLegButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 40)
    }
    
}
