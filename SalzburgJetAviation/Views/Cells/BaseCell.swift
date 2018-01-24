//
//  BaseCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/13/17.
//  Copyright © 2017 johnik703. All rights reserved.
//


import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    @objc func setupViews() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
