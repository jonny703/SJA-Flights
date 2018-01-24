//
//  TimeView.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

protocol TimeViewDelegate {
    func handleGetHour(_ hour: String)
    func handleGetMinutes(_ minutes: String)
}

class TimeView: UIView, TimeViewDelegate {
    
    var timeCellDelegate: TimeCellDelegate?
    
    var selectedHourItem: Int? {
        didSet {
            guard let index = selectedHourItem else { return }
            
            self.hoursView.selectedItem = index
        }
    }
    var selectedMinutesItem: Int? {
        didSet {
            guard let index = selectedMinutesItem else { return }
            
            self.minutesView.selectedItem = index
        }
    }
    
    lazy var hoursView: HoursView = {
        
        let view = HoursView()
        view.timeViewDelegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var minutesView: MinutesView = {
        
        let view = MinutesView()
        view.timeViewDelegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(hoursView)
        
        _ = hoursView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        hoursView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 2).isActive = true
        
        addSubview(minutesView)
        
        _ = minutesView.anchor(topAnchor, left: hoursView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    
    //MARK: handle timeview delegate to get hour, minutes format
    func handleGetHour(_ hour: String) {
        self.timeCellDelegate?.handleGetTime(hour: hour, minutes: nil)
    }
    
    func handleGetMinutes(_ minutes: String) {
        self.timeCellDelegate?.handleGetTime(hour: nil, minutes: minutes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
