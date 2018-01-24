//
//  HomeController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class HomeController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
    }
    
}

//MARK: handle controllers

extension HomeController {
    
    fileprivate func setupControllers() {
        
//        let wishListControlelr = WishListController()
//        wishListControlelr.tabBarItem.title = "WishList"
//        wishListControlelr.tabBarItem.image = UIImage(named: AssetName.blankStar.rawValue)
//        wishListControlelr.tabBarItem.selectedImage = UIImage(named: AssetName.star.rawValue)
        
        
        let availableLegsController = AvailableLegsController()
        availableLegsController.tabBarItem.title = "Available Legs"
        availableLegsController.tabBarItem.image = UIImage(named: AssetName.blankLegs.rawValue)?.withRenderingMode(.alwaysOriginal)
        availableLegsController.tabBarItem.selectedImage = UIImage(named: AssetName.legs.rawValue)
        
        let settingController = SettingController()
        settingController.tabBarItem.title = "Setting"
        settingController.tabBarItem.image = UIImage(named: AssetName.blankSetting.rawValue)?.withRenderingMode(.alwaysOriginal)
        settingController.tabBarItem.selectedImage = UIImage(named: AssetName.setting.rawValue)
        
        
        viewControllers = [availableLegsController, settingController]
        self.selectedViewController = availableLegsController
        
    }
}

extension HomeController {
    
    fileprivate func setupViews() {
        view.backgroundColor = StyleGuideManager.mainBackgroundColor
    }
    
    fileprivate func setupNavBar() {
        
        navigationController?.isNavigationBarHidden = true
        
        
    }
}

