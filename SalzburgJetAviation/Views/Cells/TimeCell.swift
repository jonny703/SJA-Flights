//
//  TimeCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

protocol TimeCellDelegate {
    func handleGetTime(hour: String?, minutes: String?)
}

class TimeCell: BaseCell, TimeCellDelegate {
    
    var calendarController: CalendarController?
    var arrivingCalendarController: ArrivingCalendarController?
    var whatTimeCell: WhatDateTime?
    
    var emptyLeg: EmptyLeg? {
        didSet {
            
            if self.whatTimeCell == .departure {
                if let hour = self.emptyLeg?.departureDateTime?.time?.hour, let minutes = self.emptyLeg?.departureDateTime?.time?.minutes {
                    self.timeView.selectedHourItem = self.handleGetIndexFromHour(hour)
                    self.timeView.selectedMinutesItem = self.handleGetIndexFromMinutes(minutes)
                }
            } else {
                if let hour = self.emptyLeg?.destinationDateTime?.time?.hour, let minutes = self.emptyLeg?.destinationDateTime?.time?.minutes {
                    self.timeView.selectedHourItem = self.handleGetIndexFromHour(hour)
                    self.timeView.selectedMinutesItem = self.handleGetIndexFromMinutes(minutes)
                }
            }
            
            if let flexibility = self.emptyLeg?.departureDateTime?.flexibility {
                
                menuBar.selectedItem = self.handleGetIndexFromFlexibility(flexibility)
                
            }
        }
    }
    
    let topLineView = UIView()
    
    lazy var menuBar: FlexibleMenuBar = {
        let mb = FlexibleMenuBar()
        mb.timeCell = self
        return mb
    }()
    
    lazy var timeView: TimeView = {
        let view = TimeView()
        view.timeCellDelegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        setupMenuBar()
        setupTimeView()
    }
    
    
    //MARK: handle timecell delegate to get hour, minutes
    func handleGetTime(hour: String?, minutes: String?) {
        
        if self.whatTimeCell == .departure {
            if let hour = hour {
                self.emptyLeg?.departureDateTime?.time?.hour = hour
            }
            
            if let minutes = minutes {
                self.emptyLeg?.departureDateTime?.time?.minutes = minutes
            }
            if let emptyLeg = self.emptyLeg {
                self.calendarController?.handleSelectedTime(emptyLeg: emptyLeg)
            }
            
        } else {
            if let hour = hour {
                self.emptyLeg?.destinationDateTime?.time?.hour = hour
            }
            
            if let minutes = minutes {
                self.emptyLeg?.destinationDateTime?.time?.minutes = minutes
            }
            if let emptyLeg = self.emptyLeg {
                self.arrivingCalendarController?.handleSelectedTime(emptyLeg: emptyLeg)
            }
        }
    }
}

//MARK: handle flexibility
extension TimeCell {
    func scrollToMenuIndex(menuIndex: Int) {
        if menuIndex == 0 {
            self.emptyLeg?.departureDateTime?.flexibility = "0"
        } else if menuIndex == 1 {
            self.emptyLeg?.departureDateTime?.flexibility = "-3"
        } else if menuIndex == 2 {
            self.emptyLeg?.departureDateTime?.flexibility = "-6"
        } else if menuIndex == 3 {
            self.emptyLeg?.departureDateTime?.flexibility = "-12"
        } else {
            self.emptyLeg?.departureDateTime?.flexibility = "-24"
        }
        
        if let emptyLeg = self.emptyLeg {
            self.calendarController?.handleSelectedFlexibility(emptyLeg: emptyLeg)
        }
    }
    
    
    
}

//MARK: handle get index from string
extension TimeCell {
    
    fileprivate func handleGetIndexFromFlexibility(_ flexibility: String) -> Int {
        
        if flexibility == "0" {
            return 0
        } else if flexibility == "-3" {
            return 1
        } else if flexibility == "-6" {
            return 2
        } else if flexibility == "-12" {
            return 3
        } else if flexibility == "-24" {
            return 4
        }
        return 0
        
    }
    
    fileprivate func handleGetIndexFromMinutes(_ minutes: String) -> Int {
        
        if minutes == "00" {
            return 0
        } else if minutes == "15" {
            return 1
        } else if minutes == "30" {
            return 2
        } else if minutes == "45" {
            return 3
        }
        
        return 0
    }
    
    fileprivate func handleGetIndexFromHour(_ hour: String) -> Int {
        
        if hour == "00" {
            return 0
        } else if hour == "12" {
            return 1
        } else if hour == "01" {
            return 2
        } else if hour == "13" {
            return 3
        } else if hour == "02" {
            return 4
        } else if hour == "14" {
            return 5
        } else if hour == "03" {
            return 6
        } else if hour == "15" {
            return 7
        } else if hour == "04" {
            return 8
        } else if hour == "16" {
            return 9
        } else if hour == "05" {
            return 10
        } else if hour == "17" {
            return 11
        } else if hour == "06" {
            return 12
        } else if hour == "18" {
            return 13
        } else if hour == "07" {
            return 14
        } else if hour == "19" {
            return 15
        } else if hour == "08" {
            return 16
        } else if hour == "20" {
            return 17
        } else if hour == "09" {
            return 18
        } else if hour == "21" {
            return 19
        } else if hour == "10" {
            return 20
        } else if hour == "22" {
            return 21
        } else if hour == "11" {
            return 22
        } else if hour == "23" {
            return 23
        }
        return 0
    }
    
}

//MARK: handle setup views
extension TimeCell {
    fileprivate func setupTimeView() {
        
        addSubview(timeView)
        
        _ = timeView.anchor(topAnchor, left: nil, bottom: menuBar.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: (DEVICE_WIDTH - 30) * 8 / 10, heightConstant: 0)
        timeView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
    }
    
    fileprivate func setupMenuBar() {
        
        addSubview(menuBar)
        
        _ = menuBar.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
    }
}

