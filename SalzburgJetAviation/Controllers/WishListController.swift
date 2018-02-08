//
//  WishListController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class WishListController: UIViewController {
    
    let cellId = "cellId"
    
    var wishLists: [WishList] = {
        
        let first = WishList(startAirPort: "Salzburg (AT)", startDistance: "(LOWS) +200km", departureAirPort: "Torino (IT)", departureDistance: "(LIMF) +0km")
        let second = WishList(startAirPort: "Klagenfurt (AT)", startDistance: "(LOWK) +200km", departureAirPort: "Munich (DE)", departureDistance: "(EDDM) +0km")
        return [first, second]
    }()
    
    var bottomLine = UIView()
    
    lazy var tableView: UITableView = {
        
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        return tv
        
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add a New Leg", for: .normal)
        button.contentHorizontalAlignment = .left
        button.tintColor = StyleGuideManager.mainYellowColor
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
    }
    
}

//MARK: handle table view
extension WishListController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WishListCell
        
        cell.wishListController = self
        
        let wishList = wishLists[indexPath.row]
        cell.wishList = wishList
        
        if indexPath.row == wishLists.count - 1 {
            cell.bottomLine.isHidden = false
        } else {
            cell.bottomLine.isHidden = true
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "I want to get notified on these legs:"
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension WishListController {
    
    fileprivate func setupViews() {
        
        view.backgroundColor = StyleGuideManager.mainBackgroundColor
        
        setupBackgrounds()
        setupAddButton()
        setupTableView()
    }
    
    private func setupAddButton() {
        
        view.addSubview(addButton)
        
        _ = addButton.anchor(nil, left: bottomLine.leftAnchor, bottom: self.bottomLayoutGuide.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 150, heightConstant: 30)
        
    }
    
    private func setupTableView() {
        
        tableView.register(WishListCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        _ = tableView.anchor(bottomLine.bottomAnchor, left: bottomLine.leftAnchor, bottom: addButton.topAnchor, right: bottomLine.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    private func setupBackgrounds() {
        
        let scoutLabel = UILabel()
        scoutLabel.text = "Empty Leg Scout"
        scoutLabel.textColor = .white
        scoutLabel.font = UIFont.systemFont(ofSize: 25)
        scoutLabel.textAlignment = .center
        
        view.addSubview(scoutLabel)
        
        _ = scoutLabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        
        let logoImageView = UIImageView()
        let logoImage = UIImage(named: AssetName.logo.rawValue)
        logoImageView.image = logoImage
        
        view.addSubview(logoImageView)
        
        _ = logoImageView.anchor(scoutLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 200 * logoImage!.size.height / logoImage!.size.width)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        bottomLine.backgroundColor = .lightGray
        
        view.addSubview(bottomLine)
        
        _ = bottomLine.anchor(nil, left: view.leftAnchor, bottom: view.centerYAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 1)
        
        
        let notifyLabel = UILabel()
        notifyLabel.text = "Get notified when an empty lef for one of your perferred routes becomes availiable."
        notifyLabel.numberOfLines = 2
        notifyLabel.font = UIFont.systemFont(ofSize: 17)
        notifyLabel.textColor = .white
        notifyLabel.textAlignment = .left
        
        view.addSubview(notifyLabel)
        
        _ = notifyLabel.anchor(nil, left: bottomLine.leftAnchor, bottom: bottomLine.topAnchor, right: bottomLine.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        
        let topLine = UIView()
        topLine.backgroundColor = .lightGray
        
        view.addSubview(topLine)
        
        _ = topLine.anchor(nil, left: bottomLine.leftAnchor, bottom: notifyLabel.topAnchor, right: bottomLine.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    fileprivate func setupNavBar() {
        
        navigationController?.isNavigationBarHidden = true
        
        
    }
    
}

