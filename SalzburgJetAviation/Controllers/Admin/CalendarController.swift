//
//  CalendarController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class CalendarController: AdminBaseController {
    
    var publishMode: PublishMode?
    
    let dateCellId = "dateCellId"
    let timeCellId = "timeCellId"
    
    var publishDelegate: PublishControllerDelegate?
    var fromWhereController: FromWhereController?
    var emptyLeg: EmptyLeg?
    
    var days: Days?
    
    let todayLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Today, 16:45"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        return label
        
    }()
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.calendarController = self
        return mb
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDateTime()
    }
    
    override func setupViews() {
        super.setupViews()
        titleLabel.text = "Departure Date/Time"
        
        setupTodayLabel()
        setupMenuBar()
        setupCollectionView()
    }
    
    override func handleNext() {
        
        let days = self.handleCalculateDifferenceDays()
        self.emptyLeg?.departureDateTime?.comingDays = days
        
        if self.fromWhereController == .publish {
            
            if let dateTime = self.emptyLeg?.departureDateTime {
                self.publishDelegate?.resetDepartureDateTime(dateTime)
                self.handleDismissController()
            }
        } else {
            let destinationController = ArrivingAirportController()
            destinationController.emptyLeg = self.emptyLeg
            destinationController.publishMode = self.publishMode
            navigationController?.pushViewController(destinationController, animated: true)
        }
    }
    
    func handleCalculateDifferenceDays() -> Int {
        
        guard let departureDateWithYearStr = emptyLeg?.departureDateTime?.dateWithYear, let depatureHour = emptyLeg?.departureDateTime?.time?.hour, let depatureMinutes = emptyLeg?.departureDateTime?.time?.minutes else { return 0 }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MMM. yyyy HH:mm"
        
        let departureDateStr = departureDateWithYearStr + " " + depatureHour + ":" + depatureMinutes
        let departureDate = formatter.date(from: departureDateStr)
        
        let days = departureDate?.days(from: Date())
        
        return days ?? 0
    }
    
    override func handleDelete() {
        self.showJHTAlertDefaultWithIcon(message: "Are you sure you want to cancel, all data will be lost?", firstActionTitle: "Continue Leg", secondActionTitle: "Cancel Leg") { (action) in
            
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: .HandlePoppingToRootNav, object: nil)
            
        }
    }
    
    func fetchDateTime() {
        
        if let dateTime = self.emptyLeg?.departureDateTime {
            
            if let dateStr = dateTime.dateWithYear, let date = self.handleGetDateWith(dateWithYear: dateStr) {
                self.handleGetNextDaysWithDate(date)
            }
            
            self.handleTodayLabelWith(dateTime: dateTime)
        } else {
            
            self.handleGetNextDaysWithDate(Date())
            self.emptyLeg?.departureDateTime = self.handleGetMainDayWithDate(Date())
        }
        self.collectionView.reloadData()
    }
    
    func handleTodayLabelWith(dateTime: DateTime) {
        if let dateStr = dateTime.date, let hour = dateTime.time?.hour, let minutes = dateTime.time?.minutes {
            self.todayLabel.text = "\(dateStr), \(hour):\(minutes)"
        }
    }
    
    func handleGetDateWith(dateWithYear: String) -> Date? {
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "EEE, d.MMM. yyyy"
        
        if let date = yearFormatter.date(from: dateWithYear) {
            return date
        }
        return nil
    }
    
    func handleGetMainDayWithDate(_ date: Date) -> DateTime {
        let todayFormatter = DateFormatter()
        let todayWithYearFormatter = DateFormatter()
        let hourFormatter = DateFormatter()
        let minutesFormatther = DateFormatter()
        
        todayFormatter.dateFormat = "EEE, d. MMM"
        todayWithYearFormatter.dateFormat = "d.MMM. yyyy"
        hourFormatter.dateFormat = "HH"
        minutesFormatther.dateFormat = "mm"
        
        let today = todayFormatter.string(from: date)
        let todayWithYear = todayWithYearFormatter.string(from: date)
        let hour = hourFormatter.string(from: date)
        let minutes = minutesFormatther.string(from: date)
        
        let minutesFormat = self.getMinutesFormatWith(minutes: Int(minutes)!)
        
        self.todayLabel.text = "Today, \(hour):\(minutesFormat)"
        
        let time = Time(hour: hour, minutes: minutesFormat)
        let departureTime = DateTime(date: today, dateWithYear: todayWithYear, time: time, flexibility: "0", minusFlexibility: "0", comingDays: 0)
        return departureTime
    }
    
    func getMinutesFormatWith(minutes: Int) -> String {
        
        if minutes >= 0 && minutes < 15 {
            return "00"
        } else if minutes >= 15 && minutes < 30 {
            return "15"
        } else if minutes >= 30 && minutes < 45 {
            return "30"
        } else {
            return "45"
        }
    }
    
    
    func handleGetNextDaysWithDate(_ date: Date) {
        
        let tomorrowDate = date.tomorrow
        let theDayAfterTomorrowDate = date.theDayAfterTomorrow
        
        let dayFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        
        dayFormatter.dateFormat = "EEEE"
        dateFormatter.dateFormat = "d.MMM. yyyy"
        
        let tomorrowDay = dayFormatter.string(from: tomorrowDate)
        let tomorrowDateStr = dateFormatter.string(from: tomorrowDate)
        
        let theDayAfterTomorrowDay = dayFormatter.string(from: theDayAfterTomorrowDate)
        let theDayAfterTomorrowDateStr = dateFormatter.string(from: theDayAfterTomorrowDate)
        
        
        let tomorrow = NextDay(day: tomorrowDay, date: tomorrowDateStr, realDate: tomorrowDate)
        let theDayAfterTomorrow = NextDay(day: theDayAfterTomorrowDay, date: theDayAfterTomorrowDateStr, realDate: theDayAfterTomorrowDate)
        
        self.days = Days(today: date, tomorrow: tomorrow, theDayAfterTomorrw: theDayAfterTomorrow)
    }
    
    func handleSelectedDate(_ date: String, dateWithYear: String) {
        
        self.emptyLeg?.departureDateTime?.date = date
        self.emptyLeg?.departureDateTime?.dateWithYear = dateWithYear
        
        if let dateWithYearStr = self.handleGetDateWith(dateWithYear: dateWithYear) {
            self.handleGetNextDaysWithDate(dateWithYearStr)
            self.collectionView.reloadData()
        }
        
        if let dateTime = self.emptyLeg?.departureDateTime {
            self.handleTodayLabelWith(dateTime: dateTime)
        }
        
        self.scrollToMenuIndex(menuIndex: 1)
    }
    
    func handleSelectedTime(emptyLeg: EmptyLeg) {
        
        self.emptyLeg = emptyLeg
        if let dateTime = self.emptyLeg?.departureDateTime {
            self.handleTodayLabelWith(dateTime: dateTime)
        }
    }
    
    func handleSelectedFlexibility(emptyLeg: EmptyLeg) {
        self.emptyLeg = emptyLeg
    }
}

//MARK: handle collectionview
extension CalendarController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateCellId, for: indexPath) as! DateCell
            
            cell.calendarController = self
            cell.whatDateCell = .departure
            
            if let days = self.days {
                cell.days = days
            }
            
            return cell
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timeCellId, for: indexPath) as! TimeCell
            
            cell.calendarController = self
            cell.whatTimeCell = .departure
            
            if let emptyLeg = self.emptyLeg {
                cell.emptyLeg = emptyLeg
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: view.frame.height - 225)
    }
    
    
}

//MARK: handle scroll
extension CalendarController {
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let index = targetContentOffset.pointee.x / (view.frame.width - 30)
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])

    }
}


extension CalendarController {
    
    fileprivate func setupCollectionView() {
        
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: dateCellId)
        collectionView.register(TimeCell.self, forCellWithReuseIdentifier: timeCellId)
        
        collectionView.isPagingEnabled = true
        
        view.addSubview(collectionView)
        
        _ = collectionView.anchor(menuBar.bottomAnchor, left: lineView.leftAnchor, bottom: bottomLineView.topAnchor, right: lineView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func setupMenuBar() {
        
        view.addSubview(menuBar)
        
        _ = menuBar.anchor(todayLabel.bottomAnchor, left: lineView.leftAnchor, bottom: nil, right: lineView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
    }
    
    fileprivate func setupTodayLabel() {
        
        view.addSubview(todayLabel)
        
        _ = todayLabel.anchor(lineView.bottomAnchor, left: lineView.leftAnchor, bottom: nil, right: lineView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
    }
    
}
