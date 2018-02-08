//
//  Extension+Double.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 2/8/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation

extension Double {
    //    var clean: String { return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", self) : String(self) }
    
    var clean: String {
        return  String(format: "%.2f", self)
    }
    
    var cleanKm: String {
        return  String(format: "%d", self)
    }
    
}
