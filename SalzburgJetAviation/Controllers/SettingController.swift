//
//  SettingController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

protocol SettingControllerDelegate {
    
    func handleLoginAfterDismiss()
    
}

import UIKit
import PermissionScope
import OneSignal

class SettingController: UIViewController {
    
    let cellId = "cellId"
    let pushCellId = "pushCellId"
    
    let permissionScope = PermissionScope()
    
    var settings: [Setting] = {
        
        let pushSetting = Setting(isChecked: true, title: "Push Notification")
        let loginSetting = Setting(isChecked: nil, title: "Log In(Admin)")
        
        return [pushSetting, loginSetting]
    }()
    
    let settingLabel = UILabel()
    
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
        addNotification()
        setupViews()
        
        permissionScope.addPermission(NotificationsPermission(notificationCategories: nil), message: "We use this to send you new empty legs available")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        checkPushNotificationIsOn()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HandlePoppingToRootNav, object: nil)
    }
    
    fileprivate func isLoggedIn() -> Bool {
        
        return UserDefaults.standard.isLoggedIn()
    }
    
    private func addNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleGoingToCreateEmptyControllerAfterPopping), name: .HandlePoppingToRootNav, object: nil)
        
    }
}

//MARK: handle permission
extension SettingController {
    
    fileprivate func checkPushNotificationIsOn() {
        
        switch PermissionScope().statusNotifications() {
        case .unknown:
            // ask
            print("unknown permission")
            self.settings[0].isChecked = false
        case .unauthorized, .disabled:
            
            //bummer
            print("disabled permission")
            self.settings[0].isChecked = false
        case .authorized:
            
            // thanks
            print("enabled permission")
            self.settings[0].isChecked = true
        }
        
        self.tableView.reloadData()
        
    }
    
    func handlePushNotificaion(ForCell cell: SettingPushNotificationCell) {
        
        switch PermissionScope().statusNotifications() {
        case .unknown:
            // ask
            print("unknown permission")
            
            self.permissionScope.show({ (finished, results: [PermissionResult]) in
                print("results: ", results)
                
                if results[0].status == PermissionStatus.authorized {
                    self.settings[0].isChecked = true
                    OneSignal.setSubscription(true)
                    self.tableView.reloadData()
                } else {
                    self.settings[0].isChecked = false
                    self.tableView.reloadData()
                }
                
            }, cancelled: { (results) in
                print("canceld")
                self.settings[0].isChecked = false
                self.tableView.reloadData()
            })
        case .unauthorized, .disabled:
            
            //bummer
            print("disabled permission")
            
            self.permissionScope.show({ (finished, results: [PermissionResult]) in
                print("results: ", results)
                
                if results[0].status == PermissionStatus.authorized {
                    self.settings[0].isChecked = true
                    OneSignal.setSubscription(true)
                    self.tableView.reloadData()
                } else {
                    self.settings[0].isChecked = false
                    self.tableView.reloadData()
                }
                
            }, cancelled: { (results) in
                print("canceld")
                self.settings[0].isChecked = false
                self.tableView.reloadData()
            })
        case .authorized:
            
            // thanks
            print("enabled permission")
            self.handleOnesignal(AndCell: cell)
        }
    }
    
    private func handleOnesignal(AndCell cell: SettingPushNotificationCell) {
        let isOn = cell.pushSwitch.isOn
        OneSignal.setSubscription(isOn)
        
        self.settings[0].isChecked = isOn
        self.tableView.reloadData()
    }
    
}

//MARK: handle login
extension SettingController: SettingControllerDelegate {
    
    func handleLoginAfterDismiss() {
        handleGoingToCreateEmptyController()
    }
    
    
    fileprivate func handleLogin() {
        if isLoggedIn() {
            handleGoingToCreateEmptyController()
        } else {
            handleGoingToLoginController()
        }
    }
    
    private func handleGoingToCreateEmptyController() {
        let createNewLegController = CreateEmptyLegController()
        navigationController?.pushViewController(createNewLegController, animated: true)
    }
    
    @objc fileprivate func handleGoingToCreateEmptyControllerAfterPopping() {
        let createNewLegController = CreateEmptyLegController()
        navigationController?.pushViewController(createNewLegController, animated: false)
    }
    
    private func handleGoingToLoginController() {
        let loginController = LoginController()
        loginController.settingDelegate = self
        navigationController?.pushViewController(loginController, animated: true)
    }
}

//MARK: handle table view
extension SettingController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: pushCellId, for: indexPath) as! SettingPushNotificationCell
            
            cell.settingController = self
            
            let setting = settings[indexPath.row]
            cell.titleLabel.text = setting.title
            cell.pushIsOn = setting.isChecked
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingCell
            
            cell.settingController = self
            
            let setting = settings[indexPath.row]
            cell.titleLabel.text = setting.title
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            
            self.handleLogin()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


extension SettingController {
    
    fileprivate func setupViews() {
        
        setupBackgrounds()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.register(SettingCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SettingPushNotificationCell.self, forCellReuseIdentifier: pushCellId)
        
        view.addSubview(tableView)
        
        _ = tableView.anchor(settingLabel.bottomAnchor, left: view.leftAnchor, bottom: self.bottomLayoutGuide.topAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
    }
    
    private func setupBackgrounds() {
        
        view.backgroundColor = StyleGuideManager.mainBackgroundColor
        
        
        settingLabel.text = "Settings"
        settingLabel.textColor = .white
        settingLabel.textAlignment = .center
        settingLabel.font = UIFont.systemFont(ofSize: 23)
        
        view.addSubview(settingLabel)
        
        _ = settingLabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 25)
        
    }
    
    fileprivate func setupNavBar() {
        
        navigationController?.isNavigationBarHidden = true
        
        
    }
    
}
