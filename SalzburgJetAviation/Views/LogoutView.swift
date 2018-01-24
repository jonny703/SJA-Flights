//
//  LogoutView.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class LogoutView: UIView {
    
    let lockImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: AssetName.lock.rawValue)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .white
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Log out"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(lockImageView)
        addSubview(titleLabel)
        
        _ = lockImageView.anchor(topAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.size.height * 2 / 3 , heightConstant: frame.size.height * 2 / 3)
        lockImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = titleLabel.anchor(lockImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
