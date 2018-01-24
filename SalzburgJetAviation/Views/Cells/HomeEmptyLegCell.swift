//
//  HomeEmptyLegCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/17/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class HomeEmptyLegCell: EmptyLegCell {
    
    override func setupViews() {
        
        super.setupViews()
        
        backgroundColor = StyleGuideManager.mainDarkBackgroundColor
        bottomLineView.isHidden = true
        
        layer.borderColor = StyleGuideManager.mainLineBackgroundColor.cgColor
        layer.borderWidth = 0.8
        layer.cornerRadius = 10
        clipsToBounds = true
        
        aircraftLabel.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        departureAirPortLabel.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        departureDateLabel.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        departureTimeLabel.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        destinationAirPortLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        destinationDateLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        destinationTimeLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        priceLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    
}
