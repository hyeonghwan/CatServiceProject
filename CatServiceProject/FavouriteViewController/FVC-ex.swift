//
//  FVC-ex.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/18.
//

import Foundation
import UIKit
import SnapKit

extension FavouriteViewController {
    func layoutConfigure(_ collectionView: UICollectionView) {
        self.view.backgroundColor = .systemCyan
        collectionView.delegate = self
        collectionView.register(FavouriteCell.self, forCellWithReuseIdentifier: FavouriteCell.identify)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
extension FavouriteViewController: DeleteFavouriteCellDelegate{
    func deleteFavouriteDataFromCell(_ favourite_id: Int,_ indexPath: IndexPath) {
//        self.favourtieViewModel.deleteFavouriteCellData(favourite_id,indexPath)
        
    }
}

extension FavouriteViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.width / 2 - 16
        
        return CGSize(width: size, height: size + 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = CGFloat(10)
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 38
    }
    
}
extension FavouriteViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
    }
    
}


//extension FavouriteViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return favourtieViewModel.numberOfInsection()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCell", for: indexPath) as? FavouriteCell else {print("updateUI(_ image: UIImage)"); return UICollectionViewCell()}
//
//        cell.updateUI(favourtieViewModel.favoriteCellModel[indexPath.row],
//                      indexPath,
//                      self)
//
//        return cell
//    }
//}
