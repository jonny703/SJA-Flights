//
//  LocationCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class AirportCell: BaseTableViewCell {
    
    var airportsController: AirportsController?
    
    var pickedAirport: PickedAirport? {
        
        didSet {
            guard let pickedAirport = pickedAirport else { return }
            guard let isPicked = pickedAirport.isPicked else { return }
            
            var titleColor: UIColor
            var detailTitleColor: UIColor
            
            if isPicked {
                titleColor = StyleGuideManager.mainYellowColor
                detailTitleColor = StyleGuideManager.mainYellowColor
            } else {
                titleColor = .white
                detailTitleColor = .gray
            }
            
            guard let icao = pickedAirport.airport?.icao, let name = pickedAirport.airport?.name else { return }
            
            
            let attributedText = NSMutableAttributedString(string: icao.trimmingCharacters(in: .whitespacesAndNewlines), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.foregroundColor: titleColor])
            attributedText.append(NSAttributedString(string: " (\(name.trimmingCharacters(in: .whitespacesAndNewlines)))", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: detailTitleColor]))
            let paragraphStrye = NSMutableParagraphStyle()
            paragraphStrye.alignment = .left
            
            let length = attributedText.string.count
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
            
            self.titleLabel.attributedText = attributedText
            
            
            var detailText = ""
            if let iata = pickedAirport.airport?.iata {
                detailText += iata.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if let city = pickedAirport.airport?.city {
                detailText += ", " + city.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if let country = pickedAirport.airport?.country {
                detailText += ", " + country.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            self.subTitleLabel.text = detailText
            self.subTitleLabel.textColor = detailTitleColor
        }
        
    }
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
    
    override func setupViews() {
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(titleLabel)
        
        _ = titleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        addSubview(subTitleLabel)
        
        _ = subTitleLabel.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
    }
    
}

