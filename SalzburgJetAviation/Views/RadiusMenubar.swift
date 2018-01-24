//
//  RadiusMenubar.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class RadiusMenuBar: MenuBar {
    
    override func setupViews() {
        
        self.title = "Radius:"
        self.titleNames = ["100 km", "Exact"]
        
        super.setupViews()
        
    }
    
}

