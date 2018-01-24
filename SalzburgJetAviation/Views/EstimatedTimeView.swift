//
//  EstimatedTimeView.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/13/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

protocol EstimatedTimeViewDelegate {
    func handleGetHour(_ hour: String)
    func handleGetMinutes(_ minutes: String)
}

class EstimatedTimeView: UIView {
    
    var estimatedTimeController: EstimatedTimeController?
    
    var selectedHourItem: Int? {
        didSet {
            guard let index = selectedHourItem else { return }
            
            self.estimatedHoursView.selectedItem = index
        }
    }
    var selectedMinutesItem: Int? {
        didSet {
            guard let index = selectedMinutesItem else { return }
            
            self.estimatedMinutesView.selectedItem = index
        }
    }
    
    lazy var estimatedHoursView: EstimatedHoursView = {
        
        let view = EstimatedHoursView()
        view.estimatedTimeViewDelegate = self
        return view
        
    }()
    
    lazy var estimatedMinutesView: EstimatedMinutesView = {
        let view = EstimatedMinutesView()
        view.estimatedTimeViewDelegate = self
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    
    
    func setupViews() {
        addSubview(estimatedHoursView)
        
        _ = estimatedHoursView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        estimatedHoursView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 2).isActive = true
        
        addSubview(estimatedMinutesView)
        
        _ = estimatedMinutesView.anchor(topAnchor, left: estimatedHoursView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EstimatedTimeView: EstimatedTimeViewDelegate {
    func handleGetHour(_ hour: String) {
        self.estimatedTimeController?.handleSelectedHour(hour, minutes: nil)
    }
    
    func handleGetMinutes(_ minutes: String) {
        self.estimatedTimeController?.handleSelectedHour(nil, minutes: minutes)
    }
    
    
}
