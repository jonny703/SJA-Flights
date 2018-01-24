//
//  SettingPushNotificationCe;;.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/14/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import OneSignal

class SettingPushNotificationCell: SettingCell {
    
    var pushIsOn: Bool? {
        
        didSet {
            guard let isOn = pushIsOn else { return }
            pushSwitch.isOn = isOn
            if isOn {
                pushSwitch.thumbTintColor = .gray
            } else {
                pushSwitch.thumbTintColor = StyleGuideManager.mainYellowColor
            }
        }
        
        
    }
    
    lazy var pushSwitch: UISwitch = {
        let pushSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        pushSwitch.thumbTintColor = StyleGuideManager.mainYellowColor
        pushSwitch.onTintColor = StyleGuideManager.mainYellowColor
        pushSwitch.addTarget(self, action: #selector(handlePushSwitch(sender:)), for: .valueChanged)
        return pushSwitch
    }()
    
    @objc fileprivate func handlePushSwitch(sender: UISwitch) {
        
//        OneSignal.setSubscription(sender.isOn)
        settingController?.handlePushNotificaion(ForCell: self)
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        keyImageView.isHidden = true
        
        pushSwitch.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        accessoryView = pushSwitch
        
        _ = titleLabel.anchor(nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    }
    
}
