//
//  SettingCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit



class SettingCell: BaseTableViewCell {
    
    var settingController: SettingController?
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
        
    }()
    
    let keyImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: AssetName.key.rawValue)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = StyleGuideManager.mainYellowColor
        return imageView
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
        
        let disclosureImage = UIImage(named: AssetName.disclosure.rawValue)?.withRenderingMode(.alwaysTemplate)
        let disclosureImageView = UIImageView(image: disclosureImage)
        disclosureImageView.tintColor = .gray
        disclosureImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        accessoryView = disclosureImageView
        
        
        
        addSubview(keyImageView)
        addSubview(titleLabel)
        
        let keyImage = UIImage(named: AssetName.key.rawValue)
        _ = keyImageView.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 45, heightConstant: 45 * keyImage!.size.height / keyImage!.size.width)
        keyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        _ = titleLabel.anchor(nil, left: keyImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(topLine)
        addSubview(bottomLine)
        
        _ = topLine.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = bottomLine.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    @objc private func handleCheck() {
        
        //        settingController?.handleCheck(cell: self)
        
    }
}
