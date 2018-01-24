//
//  SortByMenuBar.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/10/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class SortByMenuBar: MenuBar {
    
    var creatEmptyController: CreateEmptyLegController?
    
    override func setupViews() {
        
        self.title = "Sort by:"
        self.titleNames = ["Aircraft", "Date"]
        
        super.setupViews()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        creatEmptyController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
}

