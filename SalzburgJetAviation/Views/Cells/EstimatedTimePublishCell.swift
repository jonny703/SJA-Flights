//
//  EstimatedTimePublishCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/14/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class EstimatedTimePublishCell: AircraftPublishCell {
    
    var estimatedTime: Time? {
        
        didSet {
            
            guard let estimatedTime = estimatedTime else { return }
            
            if let hour = estimatedTime.hour, let minutes = estimatedTime.minutes {
                guard let hourInt = Int(hour) else { return }
                let attributedText = NSMutableAttributedString(string: String(describing: hourInt), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.foregroundColor: UIColor.white])
                attributedText.append(NSAttributedString(string: " Hours ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.gray]))
                attributedText.append(NSAttributedString(string: minutes, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.foregroundColor: UIColor.white]))
                attributedText.append(NSAttributedString(string: " Minutes", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.gray]))
                let paragraphStrye = NSMutableParagraphStyle()
                paragraphStrye.alignment = .left
                
                let length = attributedText.string.count
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
                
                self.titleLabel.attributedText = attributedText
                
            }
            
        }
        
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        self.subTitleLabel.text = "Estimated Flight Time"
    }
    
}
