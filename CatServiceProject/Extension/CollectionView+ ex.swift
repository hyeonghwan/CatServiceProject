//
//  CollectionView+ ex.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/16.
//

import Foundation
import UIKit

extension UICollectionView {
    static func collectionConfigure() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CatCollectionViewCell.self, forCellWithReuseIdentifier: CatCollectionViewCell.identify)
        
        return collectionView
    }
}
