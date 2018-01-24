//
//  EstimatedMinutesView.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/13/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class EstimatedMinutesView: EstimatedHoursView {
    
    override func setupViews() {
        super.setupViews()
        titleNames = [
            HourTitle(color: .lightGray, hour: "00"),
            HourTitle(color: .lightGray, hour: "05"),
            HourTitle(color: .lightGray, hour: "10"),
            HourTitle(color: .lightGray, hour: "15"),
            HourTitle(color: .lightGray, hour: "20"),
            HourTitle(color: .lightGray, hour: "25"),
            HourTitle(color: .lightGray, hour: "30"),
            HourTitle(color: .lightGray, hour: "35"),
            HourTitle(color: .lightGray, hour: "40"),
            HourTitle(color: .lightGray, hour: "45"),
            HourTitle(color: .lightGray, hour: "50"),
            HourTitle(color: .lightGray, hour: "55"),
        ]
        
        
        
    }
    
    override func setCollectionView() {
        super.setCollectionView()
        collectionView.register(EstimatedMinuteCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EstimatedMinuteCell
        
        let hourTitle = titleNames[indexPath.item]
        cell.hourTitle = hourTitle
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let minutes = titleNames[indexPath.item].hour
                self.estimatedTimeViewDelegate?.handleGetMinutes(minutes)
    }
}

class EstimatedMinuteCell: HourCell {
    
    override func setupViews() {
        super.setupViews()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textAlignment = .center
    }
    
}
