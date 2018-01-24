//
//  MinutesView.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class MinutesView: HoursView {
    
    override func setupViews() {
        
        titleNames = [
            HourTitle(color: .lightGray, hour: "00"),
            HourTitle(color: .lightGray, hour: "15"),
            HourTitle(color: .lightGray, hour: "30"),
            HourTitle(color: .lightGray, hour: "45"),
        ]
        
        super.setupViews()
        
    }
    
    override func setCollectionView() {
        super.setCollectionView()
        collectionView.register(MinuteCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MinuteCell
        
        let hourTitle = titleNames[indexPath.item]
        cell.hourTitle = hourTitle
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width, height: frame.height / 4)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let minutes = titleNames[indexPath.item].hour
        self.timeViewDelegate?.handleGetMinutes(minutes)
    }
}

class MinuteCell: HourCell {
    
    override func setupViews() {
        super.setupViews()
        
//        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textAlignment = .left
        titleLabel.padding = UIEdgeInsets(top: 0, left: (DEVICE_WIDTH - 30) / 10 - 5, bottom: 0, right: 0)
        
        
    }
    
}
