//
//  AircraftPublishCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class AircraftPublishCell: BaseTableViewCell {
    
    var aircraft: Aircraft? {
        
        didSet {
            
            guard let aircraft = aircraft else { return }
            
            if let name = aircraft.name, let detail = aircraft.detail {
                
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.foregroundColor: UIColor.white])
                attributedText.append(NSAttributedString(string: " (\(detail))", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.gray]))
                let paragraphStrye = NSMutableParagraphStyle()
                paragraphStrye.alignment = .left
                
                let length = attributedText.string.count
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
                
                self.titleLabel.attributedText = attributedText
                
            }
        }
    }
    
    let subTitleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Aircraft:"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "OE-GWH (citation Jet XLS+)"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    let disclosureImageView: UIImageView = {
        let disclosureImage = UIImage(named: AssetName.disclosure.rawValue)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: disclosureImage)
        imageView.tintColor = .gray
        return imageView
    }()
    
    override func setupViews() {
        
        backgroundColor = .clear
        
        selectionStyle = .none
        setupDisclosureImageView()
        setupSubTitleLabel()
        
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        
        _ = titleLabel.anchor(subTitleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: disclosureImageView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    }
    
    private func setupDisclosureImageView() {
        addSubview(disclosureImageView)
        
        _ = disclosureImageView.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        disclosureImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupSubTitleLabel() {
        
        addSubview(subTitleLabel)
        
        _ = subTitleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
    }
    
}
