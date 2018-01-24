//
//  PricePublishCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/14/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class PricePublishCell: AircraftPublishCell {
    
    var price: String? {
        
        didSet {
            guard let price = price else { return }
            
            let attributedText = NSMutableAttributedString(string: price, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.foregroundColor: UIColor.white])
            attributedText.append(NSAttributedString(string: " Euro", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.gray]))
            let paragraphStrye = NSMutableParagraphStyle()
            paragraphStrye.alignment = .left
            
            let length = attributedText.string.count
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
            
            self.titleLabel.attributedText = attributedText
        }
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.subTitleLabel.text = "Price"
    }
    
}
