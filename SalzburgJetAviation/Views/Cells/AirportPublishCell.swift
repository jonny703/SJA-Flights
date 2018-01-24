//
//  AirportPublishCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

enum WhereAirport {
    case departure
    case destination
}

class AirportPublishCell: AircraftPublishCell {
    
    var whereAirPort: WhereAirport?
    
    var airport: Airport? {
        
        didSet {
            guard let airport = airport else { return }
            
            if self.whereAirPort == .departure {
                subTitleLabel.text = "Departing from:"
            } else {
                subTitleLabel.text = "Arriving at:"
            }
            
            guard let icao = airport.icao, let name = airport.name else { return }
            
            
            let attributedText = NSMutableAttributedString(string: icao.trimmingCharacters(in: .whitespacesAndNewlines), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.foregroundColor: UIColor.white])
            attributedText.append(NSAttributedString(string: " (\(name.trimmingCharacters(in: .whitespacesAndNewlines)))", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.gray]))
            let paragraphStrye = NSMutableParagraphStyle()
            paragraphStrye.alignment = .left
            
            let length = attributedText.string.count
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
            
            self.titleLabel.attributedText = attributedText
            
            
            var detailText = ""
            if let iata = airport.iata {
                detailText += iata.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if let city = airport.city {
                detailText += ", " + city.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if let country = airport.country {
                detailText += ", " + country.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            self.countryTitleLabel.text = detailText
            
//            if let name = airport.name, let country = airport.country, let city = airport.city {
//
//                let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.foregroundColor: UIColor.white])
//                attributedText.append(NSAttributedString(string: " (\(city), \(country))", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.gray]))
//                let paragraphStrye = NSMutableParagraphStyle()
//                paragraphStrye.alignment = .left
//
//                let length = attributedText.string.count
//                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
//
//                self.titleLabel.attributedText = attributedText
//
//            }
        }
        
    }
    
    let countryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Aircraft:"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(countryTitleLabel)
        
        _ = countryTitleLabel.anchor(titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    }
    
}
