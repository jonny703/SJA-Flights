//
//  MenuCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/14/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
class MenuCell: BaseCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Followers"
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? StyleGuideManager.mainYellowColor : .lightGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? StyleGuideManager.mainYellowColor : .lightGray
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        addConnstraintsWith(Format: "H:|[v0]|", views: titleLabel)
        addConnstraintsWith(Format: "V:[v0(28)]", views: titleLabel)
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
