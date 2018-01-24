//
//  PickAircraftCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class PickAircraftCell: BaseTableViewCell {
    
    var pickAircraftController: PickAircraftController?
    
    var pickedAircraft: PickedAircraft? {
        
        didSet {
            
            guard let pickedAircraft = pickedAircraft else { return }
            
            if let isPicked = pickedAircraft.isPicked, let name = pickedAircraft.aircraft?.name, let detail = pickedAircraft.aircraft?.detail {
                var titleColor: UIColor
                var detailTitleColor: UIColor
                
                if isPicked {
                    titleColor = StyleGuideManager.mainYellowColor
                    detailTitleColor = StyleGuideManager.mainYellowColor
                } else {
                    titleColor = .white
                    detailTitleColor = .gray
                }
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.foregroundColor: titleColor])
                attributedText.append(NSAttributedString(string: " (\(detail))", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: detailTitleColor]))
                let paragraphStrye = NSMutableParagraphStyle()
                paragraphStrye.alignment = .left
                
                let length = attributedText.string.count
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
                
                self.titleLabel.attributedText = attributedText
            }
        }
        
    }
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "OE-GWH (citation Jet XLS+)"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    override func setupViews() {
        
        backgroundColor = .clear
        
        selectionStyle = .none
        
        addSubview(titleLabel)
        
        _ = titleLabel.anchor(nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
    }
    
}
