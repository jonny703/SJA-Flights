//
//  StyleGuideManager.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

public class StyleGuideManager {
    private init(){}
    
    static let sharedInstance : StyleGuideManager = {
        let instance = StyleGuideManager()
        return instance
    }()
    
    //intro
    static let mainBackgroundColor = UIColor(r: 21, g: 37, b: 64)
    static let mainDarkBackgroundColor = UIColor(r: 1, g: 18, b: 48)
    static let mainLineBackgroundColor = UIColor(r: 57, g: 63, b: 77)
    static let mainYellowColor = UIColor(r: 243, g: 198, b: 0)
    
    //Fonts
    func loginFontLarge() -> UIFont {
        return UIFont(name: "Helvetica Light", size: 30)!
        
    }
}

