//
//  DateCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import FSCalendar

class DateCell: BaseCell {
    
    var calendarController: CalendarController?
    var arrivingCalendarController: ArrivingCalendarController?
    var whatDateCell: WhatDateTime?
    
    var days: Days? {
        
        didSet {
            
            guard let days = days else { return }
            
            if let date = days.today {
                self.calendar.select(date, scrollToDate: true)
            }
            
            
            if let tomorrow = days.tomorrow, let tomorrowDay = tomorrow.day, let tomorrowDate = tomorrow.date {
                let attributedText = NSMutableAttributedString(string: tomorrowDay, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.foregroundColor: UIColor.white])
                attributedText.append(NSAttributedString(string: " (\(tomorrowDate))", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.gray]))
                let paragraphStrye = NSMutableParagraphStyle()
                paragraphStrye.alignment = .left
                
                let length = attributedText.string.count
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
                self.tomorrowButton.setAttributedTitle(attributedText, for: .normal)
                self.tomorrowButton.contentHorizontalAlignment = .left
            }
            
            if let theDayAfterTomorrow = days.theDayAfterTomorrw, let theDayAfterTomorrowDay = theDayAfterTomorrow.day, let theDayAfterTomorrowDate = theDayAfterTomorrow.date {
                let attributedText = NSMutableAttributedString(string: theDayAfterTomorrowDay, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.foregroundColor: UIColor.white])
                attributedText.append(NSAttributedString(string: " (\(theDayAfterTomorrowDate))", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.gray]))
                let paragraphStrye = NSMutableParagraphStyle()
                paragraphStrye.alignment = .left
                
                let length = attributedText.string.count
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStrye, range: NSRange(location: 0, length: length))
                self.theDayAfterTomorrowButton.setAttributedTitle(attributedText, for: .normal)
                self.theDayAfterTomorrowButton.contentHorizontalAlignment = .left
            }
            
        }
        
    }
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.appearance.headerTitleColor = .lightGray
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.selectionColor = StyleGuideManager.mainYellowColor
        calendar.appearance.titleSelectionColor = .black
        calendar.appearance.headerDateFormat = "MMMM             YYY"
        calendar.appearance.borderRadius = 0.2
        calendar.delegate = self
        return calendar
    }()
    
    let topLineView = UIView()
    let bottomLineView = UIView()
    
    lazy var tomorrowButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSelectTomorrow), for: .touchUpInside)
        return button
        
    }()
    
    lazy var theDayAfterTomorrowButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSelectTheDayAfterTomorrow), for: .touchUpInside)
        return button
        
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupButtons()
        setupLines()
        setupCalendar()
    }
    
    
    
}


//MARK: handle selecct next days
extension DateCell {
    @objc fileprivate func handleSelectTomorrow() {
        if let date = days?.tomorrow?.realDate {
            self.calendar.select(date, scrollToDate: true)
            self.handleSelectedDate(date)
        }
    }
    
    @objc fileprivate func handleSelectTheDayAfterTomorrow() {
        if let date = days?.theDayAfterTomorrw?.realDate {
            self.calendar.select(date, scrollToDate: true)
            self.handleSelectedDate(date)
        }
    }
    
    fileprivate func handleSelectedDate(_ date: Date) {
        let selectedFormatter = DateFormatter()
        let selectedFormatterWithYear = DateFormatter()
        
        selectedFormatter.dateFormat = "EEE, d. MMM"
        selectedFormatterWithYear.dateFormat = "d.MMM. yyyy"
        
        let selectedDate = selectedFormatter.string(from: date)
        let selectedDateWithYear = selectedFormatterWithYear.string(from: date)
        
        print("date: ", selectedDate, selectedDateWithYear)
        
        if self.whatDateCell == .departure {
            self.calendarController?.handleSelectedDate(selectedDate, dateWithYear: selectedDateWithYear)
        } else {
            self.arrivingCalendarController?.handleSelectedDate(selectedDate, dateWithYear: selectedDateWithYear)
        }
    }
}

//MARK handle calendar delegate
extension DateCell: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.handleSelectedDate(date)
    }
    
}


//MARK: handle setupViews
extension DateCell {
    fileprivate func setupCalendar() {
        addSubview(calendar)
        
        _ = calendar.anchor(topLineView.bottomAnchor, left: leftAnchor, bottom: bottomLineView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func setupLines() {
        
        topLineView.backgroundColor = .lightGray
        addSubview(topLineView)
        
        _ = topLineView.anchor(theDayAfterTomorrowButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        
        bottomLineView.backgroundColor = .lightGray
        addSubview(bottomLineView)
        
        _ = bottomLineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    fileprivate func setupButtons() {
        addSubview(tomorrowButton)
        
        _ = tomorrowButton.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        addSubview(theDayAfterTomorrowButton)
        
        _ = theDayAfterTomorrowButton.anchor(tomorrowButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    }
}


