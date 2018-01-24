//
//  HoursCell.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

struct HourTitle {
    let color: UIColor
    let hour: String
}

class HoursView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var timeViewDelegate: TimeViewDelegate?
    
    var selectedItem: Int? {
        didSet {
            guard let index = selectedItem else { return }
            
            let selectedIndexPath = IndexPath(item: index, section: 0)
            self.collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
            
        }
    }
    
    var titleNames = [
        HourTitle(color: .darkGray, hour: "00"),
        HourTitle(color: .white, hour: "12"),
        HourTitle(color: .darkGray, hour: "01"),
        HourTitle(color: .white, hour: "13"),
        HourTitle(color: .darkGray, hour: "02"),
        HourTitle(color: .white, hour: "14"),
        HourTitle(color: .darkGray, hour: "03"),
        HourTitle(color: .white, hour: "15"),
        HourTitle(color: .darkGray, hour: "04"),
        HourTitle(color: .white, hour: "16"),
        HourTitle(color: .darkGray, hour: "05"),
        HourTitle(color: .white, hour: "17"),
        HourTitle(color: .darkGray, hour: "06"),
        HourTitle(color: .white, hour: "18"),
        HourTitle(color: .white, hour: "07"),
        HourTitle(color: .white, hour: "19"),
        HourTitle(color: .white, hour: "08"),
        HourTitle(color: .darkGray, hour: "20"),
        HourTitle(color: .white, hour: "09"),
        HourTitle(color: .darkGray, hour: "21"),
        HourTitle(color: .white, hour: "10"),
        HourTitle(color: .darkGray, hour: "22"),
        HourTitle(color: .white, hour: "11"),
        HourTitle(color: .darkGray, hour: "23")
    ]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCollectionView()
        setupViews()
    }
    
    func setCollectionView() {
        collectionView.register(HourCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func setupViews() {
        addSubview(collectionView)
        
        _ = collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
//        let selectedIndexPath = IndexPath(item: self.selectedItem ?? 0, section: 0)
//        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        calendarController?.scrollToMenuIndex(menuIndex: indexPath.item)
        let hour = titleNames[indexPath.item].hour
        self.timeViewDelegate?.handleGetHour(hour)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HourCell
        
//        cell.titleLabel.text = titleNames[indexPath.item]
//        if indexPath.item != 0 {
//            cell.titleLabel.textColor = .white
//        }
        let hourTitle = titleNames[indexPath.item]
        cell.hourTitle = hourTitle
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width / 2, height: frame.height / 12)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HourCell: MenuCell {
    
    var hourTitle: HourTitle? {
        
        didSet {
            guard let hourTitle = hourTitle else { return }
            
            if !self.isSelected {
                self.titleLabel.textColor = hourTitle.color
                
            }
            self.titleLabel.text = hourTitle.hour
            
        }
    }
    
    override func setupViews() {
        super.setupViews()
        titleLabel.layer.cornerRadius = 5
        titleLabel.layer.masksToBounds = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? .black : self.hourTitle?.color ?? .white
            titleLabel.backgroundColor = isHighlighted ? StyleGuideManager.mainYellowColor : .clear
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .black : self.hourTitle?.color ?? .white
            titleLabel.backgroundColor = isSelected ? StyleGuideManager.mainYellowColor : .clear
        }
    }
    
}
