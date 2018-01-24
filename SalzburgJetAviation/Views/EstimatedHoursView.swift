//
//  EstimatedHoursView.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/13/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class EstimatedHoursView: HoursView {
    
    var estimatedTimeViewDelegate: EstimatedTimeViewDelegate?
    
    override func setupViews() {
        
        titleNames = [
            HourTitle(color: .white, hour: "00"),
            HourTitle(color: .white, hour: "01"),
            HourTitle(color: .white, hour: "02"),
            HourTitle(color: .white, hour: "03"),
            HourTitle(color: .white, hour: "04"),
            HourTitle(color: .white, hour: "05"),
            HourTitle(color: .white, hour: "06"),
            HourTitle(color: .white, hour: "07"),
            HourTitle(color: .white, hour: "08"),
            HourTitle(color: .white, hour: "09"),
            HourTitle(color: .white, hour: "10"),
            HourTitle(color: .white, hour: "11"),
        ]
        
        super.setupViews()
        
    }
    
    override func setCollectionView() {
        super.setCollectionView()
        collectionView.register(HourCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HourCell
        
        let hourTitle = titleNames[indexPath.item]
        cell.hourTitle = hourTitle
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width, height: frame.height / 12)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let minutes = titleNames[indexPath.item].hour
        self.estimatedTimeViewDelegate?.handleGetHour(minutes)
    }
}

