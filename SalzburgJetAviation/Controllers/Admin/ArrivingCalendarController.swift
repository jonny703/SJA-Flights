//
//  ArrivingCalendarController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/10/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class ArrivingCalendarController: CalendarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel.text = "Arriving Date/Time"
    }
    
    override func fetchDateTime() {
        
        if let dateTime = self.emptyLeg?.destinationDateTime {
            
            if let dateStr = dateTime.dateWithYear, let date = self.handleGetDateWith(dateWithYear: dateStr) {
                self.handleGetNextDaysWithDate(date)
            }
            
            self.handleTodayLabelWith(dateTime: dateTime)
        } else {
            
            self.handleGetNextDaysWithDate(Date())
            self.emptyLeg?.destinationDateTime = self.handleGetMainDayWithDate(Date())
        }
        self.collectionView.reloadData()
    }
    
    override func handleNext() {
        
        if self.fromWhereController == .publish {
            if let dateTime = self.emptyLeg?.destinationDateTime {
                self.publishDelegate?.resetDepartureDateTime(dateTime)
                self.handleDismissController()
            }
        } else {
            let publishController = PublishController()
            publishController.emptyLeg = self.emptyLeg
            publishController.publishMode = self.publishMode
            navigationController?.pushViewController(publishController, animated: true)
        }
        
    }
    
    override func handleSelectedDate(_ date: String, dateWithYear: String) {
        self.emptyLeg?.destinationDateTime?.date = date
        self.emptyLeg?.destinationDateTime?.dateWithYear = dateWithYear
        
        if let dateWithYearStr = self.handleGetDateWith(dateWithYear: dateWithYear) {
            self.handleGetNextDaysWithDate(dateWithYearStr)
            self.collectionView.reloadData()
        }
        
        if let dateTime = self.emptyLeg?.destinationDateTime {
            self.handleTodayLabelWith(dateTime: dateTime)
        }
    }
    
    override func handleSelectedTime(emptyLeg: EmptyLeg) {
        self.emptyLeg = emptyLeg
        if let dateTime = self.emptyLeg?.destinationDateTime {
            self.handleTodayLabelWith(dateTime: dateTime)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateCellId, for: indexPath) as! DateCell
            
            cell.arrivingCalendarController = self
            cell.whatDateCell = .arriving
            
            if let days = self.days {
                cell.days = days
            }
            
            return cell
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timeCellId, for: indexPath) as! TimeCell
            
            cell.arrivingCalendarController = self
            cell.whatTimeCell = .arriving
            
            if let emptyLeg = self.emptyLeg {
                cell.emptyLeg = emptyLeg
            }
            return cell
        }
    }
    
}
