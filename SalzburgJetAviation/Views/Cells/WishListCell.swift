//
//  WishListCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class WishListCell: BaseTableViewCell {
    
    var wishListController: WishListController?
    
    var wishList: WishList? {
        didSet {
            
            guard let wishList = wishList else { return }
            
            if let startAirPort = wishList.startAirPort {
                self.startAirPortLabel.text = startAirPort
            }
            
            if let startDistance = wishList.startDistance {
                self.startDistanceLabel.text = startDistance
            }
            
            if let departureAirPort = wishList.departureAirPort {
                self.departureAirPortLabel.text = departureAirPort
            }
            
            if let departureDistance = wishList.departureDistance {
                self.departureDistanceLabel.text = departureDistance
            }
            
        }
    }
    
    let startAirPortLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let startDistanceLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let departureAirPortLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let departureDistanceLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let rightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: AssetName.rightArrow.rawValue)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .gray
        return imageView
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.cross.rawValue)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .gray
//        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return button
    }()
    
    let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override func setupViews() {
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(startAirPortLabel)
        addSubview(startDistanceLabel)
        addSubview(deleteButton)
        addSubview(departureAirPortLabel)
        addSubview(departureDistanceLabel)
        addSubview(rightArrowImageView)
        
        _ = startAirPortLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 20)
        
        _ = startDistanceLabel.anchor(nil, left: startAirPortLabel.leftAnchor, bottom: bottomAnchor, right: startAirPortLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        _ = rightArrowImageView.anchor(nil, left: startAirPortLabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        rightArrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        _ = deleteButton.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        _ = departureAirPortLabel.anchor(startAirPortLabel.topAnchor, left: rightArrowImageView.rightAnchor, bottom: nil, right: deleteButton.leftAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        _ = departureDistanceLabel.anchor(startDistanceLabel.topAnchor, left: departureAirPortLabel.leftAnchor, bottom: nil, right: departureAirPortLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        addSubview(topLine)
        addSubview(bottomLine)
        
        _ = topLine.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = bottomLine.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    }
    
    @objc private func handleDelete() {
        
//        wishListController?.handleDelete(cell: self)
        
    }
}
