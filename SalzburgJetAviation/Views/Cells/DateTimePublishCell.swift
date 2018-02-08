//
//  DateTimePublishCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

enum WhatDateTime {
    case departure
    case arriving
}

class DateTimePublishCell: AircraftPublishCell {
    
    var whatDateTime: WhatDateTime?
    
    var dateTime: DateTime? {
        
        didSet {
            
            
            
            guard let dateTime = dateTime else { return }
            
            if let date = dateTime.date, let comingDays = dateTime.comingDays {
                var comingDaysStr = "Today"
                if comingDays > 0 {
                    comingDaysStr = "In \(comingDays) Days"
                } else if comingDays < 0 {
                    comingDaysStr = "\(abs(comingDays)) Days Ago"
                }
                
                let attributedText = NSMutableAttributedString(string: date, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.foregroundColor: UIColor.white])
                attributedText.append(NSAttributedString(string: " (\(comingDaysStr))", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.gray]))
                let paragraphStrye = NSMutableParagraphStyle()
                paragraphStrye.alignment = .left
                
                let length = attributedText.string.count
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
                
                self.titleLabel.attributedText = attributedText
                
            }
            
            if let flexibility = dateTime.flexibility, let minusFlexibility = dateTime.minusFlexibility {
                let attributedText = NSMutableAttributedString(string: "Flexibility:", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: UIColor.gray])
                attributedText.append(NSAttributedString(string: " (\(minusFlexibility)h|+\(flexibility.trimmingCharacters(in: .whitespacesAndNewlines))h)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: UIColor.white]))
                let paragraphStrye = NSMutableParagraphStyle()
                paragraphStrye.alignment = .left
                
                let length = attributedText.string.count
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
                
                self.detailLabel.attributedText = attributedText
            }
            
            if let time = dateTime.time, let hour = time.hour, let minutes = time.minutes {
                self.timeLabel.text = hour + ":" + minutes
            }
        }
        
    }
    
    let timeLabel: UILabel = {
        
        let label = UILabel()
        label.text = "14:45"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        return label
        
    }()
    
    let detailLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Radius: +100km"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.subTitleLabel.text = "Date & Time"
        
        addSubview(timeLabel)
        
        _ = timeLabel.anchor(titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        addSubview(detailLabel)
        
        _ = detailLabel.anchor(timeLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
    }
    
}
