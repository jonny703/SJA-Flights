//
//  MinusFlexibleMenuBar.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 2/7/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

class MinusFlexibleMenuBar: MenuBar {
    
    var timeCell: TimeCell?
    
    var selectedItem: Int? {
        
        didSet {
            guard let index = selectedItem else { return }
            
            let selectedIndexPath = IndexPath(item: index, section: 0)
            self.collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        }
        
    }
    
    override func setupViews() {
        
        self.title = ""
        self.titleNames = ["Exact", "-3h", "-6h", "-12h", "-24h"]
        
        super.setupViews()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.titleLabel.text = titleNames[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        timeCell?.scrollToMinusMenuIndex(menuIndex: indexPath.item)
    }
    
}

