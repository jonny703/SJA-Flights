//
//  EstimatedTimeController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/13/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class EstimatedTimeController: AdminBaseController {
    
    var publishMode: PublishMode?
    
    var publishDelegate: PublishControllerDelegate?
    var fromWhereController: FromWhereController?
    var emptyLeg: EmptyLeg? {
        didSet {
            
            if let _ = self.emptyLeg?.estimatedFlightTime {
            } else {
                self.emptyLeg?.estimatedFlightTime = Time(hour: "00", minutes: "30")
            }
            
            if let hour = self.emptyLeg?.estimatedFlightTime?.hour, let minutes = self.emptyLeg?.estimatedFlightTime?.minutes {
                self.estimatedTimeLabel.text = hour + ":" + minutes
                
                self.estimatedTimeView.selectedHourItem = self.handleGetIndexFromHour(hour)
                self.estimatedTimeView.selectedMinutesItem = self.handleGetIndexFromMinutes(minutes)
            }
            
            
            
        }
    }
    
    let estimatedTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "00:45"
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var estimatedTimeView: EstimatedTimeView = {
        let view = EstimatedTimeView()
        view.estimatedTimeController = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.titleLabel.text = "Estimated Flight Time"
        
        setupTimeLabel()
        setupEstimatedTimeView()
    }
    
    override func handleNext() {
        
        if self.fromWhereController == .publish {
            
            if let estimatedTime = self.emptyLeg?.estimatedFlightTime {
                self.publishDelegate?.resetEstimatedTime(estimatedTime)
                self.handleDismissController()
            }
        } else {
            let priceController = PriceController()
            priceController.emptyLeg = self.emptyLeg
            priceController.publishMode = self.publishMode
            navigationController?.pushViewController(priceController, animated: true)
        }
        
    }
    
}

//MARK: handle selected hour and minutes
extension EstimatedTimeController {
    
    func handleSelectedHour(_ hour: String?, minutes: String?) {
        
        if let hour = hour {
            self.emptyLeg?.estimatedFlightTime?.hour = hour
        }
        
        if let minutes = minutes {
            self.emptyLeg?.estimatedFlightTime?.minutes = minutes
        }
        
    }
    
    
}

//MARK: handle get index from string
extension EstimatedTimeController {
    
    fileprivate func handleGetIndexFromMinutes(_ minutes: String) -> Int {
        
        if minutes == "00" {
            return 0
        } else if minutes == "05" {
            return 1
        } else if minutes == "10" {
            return 2
        } else if minutes == "15" {
            return 3
        } else if minutes == "20" {
            return 4
        } else if minutes == "25" {
            return 5
        } else if minutes == "30" {
            return 6
        } else if minutes == "35" {
            return 7
        } else if minutes == "40" {
            return 8
        } else if minutes == "45" {
            return 9
        } else if minutes == "50" {
            return 10
        } else if minutes == "55" {
            return 11
        }
        
        return 0
    }
    
    fileprivate func handleGetIndexFromHour(_ hour: String) -> Int {
        
        if hour == "00" {
            return 0
        } else if hour == "01" {
            return 1
        } else if hour == "02" {
            return 2
        } else if hour == "03" {
            return 3
        } else if hour == "04" {
            return 4
        } else if hour == "05" {
            return 5
        } else if hour == "06" {
            return 6
        } else if hour == "07" {
            return 7
        } else if hour == "08" {
            return 8
        } else if hour == "09" {
            return 9
        } else if hour == "10" {
            return 10
        } else if hour == "11" {
            return 11
        }
        return 0
    }
    
}

extension EstimatedTimeController {
    
    
    fileprivate func setupTimeLabel() {
        
        view.addSubview(estimatedTimeLabel)
        _ = estimatedTimeLabel.anchor(lineView.topAnchor, left: lineView.leftAnchor, bottom: nil, right: lineView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        view.addSubview(topLineView)
        _ = topLineView.anchor(estimatedTimeLabel.bottomAnchor, left: lineView.leftAnchor, bottom: nil, right: lineView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        
    }
    
    fileprivate func setupEstimatedTimeView() {
        
        view.addSubview(estimatedTimeView)
        _ = estimatedTimeView.anchor(topLineView.bottomAnchor, left: nil, bottom: bottomLineView.topAnchor, right: nil, topConstant: 60, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 150, heightConstant: 0)
        estimatedTimeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let hourLabel = UILabel()
        hourLabel.text = "Hours"
        hourLabel.textColor = .gray
        hourLabel.textAlignment = .right
        hourLabel.font = UIFont.systemFont(ofSize: 20)
        
        view.addSubview(hourLabel)
        
        _ = hourLabel.anchor(nil, left: nil, bottom: estimatedTimeView.topAnchor, right: view.centerXAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 25, widthConstant: 100, heightConstant: 30)
        
        let minuteLabel = UILabel()
        minuteLabel.text = "Minutes"
        minuteLabel.textColor = .gray
        minuteLabel.textAlignment = .left
        minuteLabel.font = UIFont.systemFont(ofSize: 20)
        
        view.addSubview(minuteLabel)
        
        _ = minuteLabel.anchor(nil, left: view.centerXAnchor, bottom: estimatedTimeView.topAnchor, right: nil, topConstant: 0, leftConstant: 25, bottomConstant: 5, rightConstant: 0, widthConstant: 100, heightConstant: 30)
        
    }
    
}
