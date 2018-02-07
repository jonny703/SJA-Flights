//
//  EmptyLegCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class EmptyLegCell: MGSwipeTableCell {
    
    var emptyLeg: EmptyLeg? {
        didSet {
            
            guard let emptyLeg = emptyLeg else { return }
            
            if let aircraftName = emptyLeg.aircraft?.name, let aircraftDetail = emptyLeg.aircraft?.detail {
                let attributedText = NSMutableAttributedString(string: aircraftName, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.white])
                attributedText.append(NSAttributedString(string: " (\(aircraftDetail))", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.gray]))
                let paragraphStrye = NSMutableParagraphStyle()
                paragraphStrye.alignment = .left
                
                let length = attributedText.string.count
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
                
                self.aircraftLabel.attributedText = attributedText
            }
            
            if let departureAirport = emptyLeg.departureAirport?.name {
                self.departureAirPortLabel.text = departureAirport.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if let departureDate = emptyLeg.departureDateTime?.dateWithYear {
                guard let date = self.handleGetDifferentFormatDate(fromDate: departureDate) else { return }
                self.departureDateLabel.text = date
            }
            
            if let departureHour = emptyLeg.departureDateTime?.time?.hour, let departureMinutes = emptyLeg.departureDateTime?.time?.minutes, let departureFlexibility = emptyLeg.departureDateTime?.flexibility, let departureMinusFlexibility = emptyLeg.departureDateTime?.minusFlexibility {
                self.departureTimeLabel.text = "\(departureHour):\(departureMinutes) (\(departureMinusFlexibility)h|+\(departureFlexibility)h)"
            }
            
            if let price = emptyLeg.price {
                self.priceLabel.text = "€ \(price)"
            }
            
            if let destinationAirport = emptyLeg.destinationAirport?.name {
                self.destinationAirPortLabel.text = destinationAirport.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            if let destinationDate = emptyLeg.destinationDateTime?.dateWithYear {
                guard let date = self.handleGetDifferentFormatDate(fromDate: destinationDate) else { return }
                self.destinationDateLabel.text = date
            }
            
            if let destinationHour = emptyLeg.destinationDateTime?.time?.hour, let destinationMinutes = emptyLeg.destinationDateTime?.time?.minutes, let destinationFlexibility = emptyLeg.destinationDateTime?.flexibility, let destinationMinusFlexibility = emptyLeg.destinationDateTime?.minusFlexibility {
                self.destinationTimeLabel.text = "\(destinationHour):\(destinationMinutes) (\(destinationMinusFlexibility)h|+\(destinationFlexibility)h)"
            }
        }
    }
    
    private func handleGetDifferentFormatDate(fromDate dateStr: String) -> String? {
        
        let oldFormatter = DateFormatter()
        let newFormatter = DateFormatter()
        
        oldFormatter.dateFormat = "EEE, d.MMM yyyy"
        newFormatter.dateFormat = "d.MMM. yyyy"
        
        guard let oldDate = oldFormatter.date(from: dateStr) else { return nil }
        
        let newDateStr = newFormatter.string(from: oldDate)
        return newDateStr
    }
    
    let aircraftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    let departureAirPortLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    let destinationAirPortLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let departureDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let destinationDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let departureTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let destinationTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: AssetName.disclosure.rawValue)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .gray
        return imageView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        setupViews()
    }
    
    
    func setupViews() {
        
        contentView.addSubview(priceLabel)
        _ = priceLabel.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 25)
        
        contentView.addSubview(aircraftLabel)
        
        _ = aircraftLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: priceLabel.leftAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 25)
        
        contentView.addSubview(containerView)
        
        _ = containerView.anchor(aircraftLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        addSubview(bottomLineView)
        
        _ = bottomLineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        containerView.addSubview(arrowImageView)
        
        _ = arrowImageView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        
        arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        arrowImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(departureAirPortLabel)
        
        _ = departureAirPortLabel.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: arrowImageView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        containerView.addSubview(destinationAirPortLabel)
        _ = destinationAirPortLabel.anchor(departureAirPortLabel.topAnchor, left: arrowImageView.rightAnchor, bottom: departureAirPortLabel.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        containerView.addSubview(departureTimeLabel)
        _ = departureTimeLabel.anchor(nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: arrowImageView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18)
        
        containerView.addSubview(destinationTimeLabel)
        _ = destinationTimeLabel.anchor(departureTimeLabel.topAnchor, left: destinationAirPortLabel.leftAnchor, bottom: departureTimeLabel.bottomAnchor, right: destinationAirPortLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        containerView.addSubview(departureDateLabel)
        _ = departureDateLabel.anchor(nil, left: departureAirPortLabel.leftAnchor, bottom: destinationTimeLabel.topAnchor, right: departureAirPortLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        containerView.addSubview(destinationDateLabel)
        _ = destinationDateLabel.anchor(departureDateLabel.topAnchor, left: destinationAirPortLabel.leftAnchor, bottom: departureDateLabel.bottomAnchor, right: destinationAirPortLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
