//
//  MainVIewController - ex.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/16.
//

import Foundation
import UIKit
import ViewAnimator

extension CatMainListViewController {
    func layoutConfigure(){
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.addSubview(collectionView)
        
        collectionView.refreshControl = self.refreshControl
        
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        
        collectionView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    @objc func handleRefreshControl(){
        self.catMainListViewModel = CatMainListViewModel()
        
        self.configureAnimation(isReverseBool: true)
        
            
            //refreshController에 진동주기 UX를 향상시킨다.
            let vibrate = UIImpactFeedbackGenerator(style: .light)
            vibrate.impactOccurred()
            
        self.catMainListViewModel.scrollRefreshingGetImage(count: 12){ item in
                self.collectionView.reloadData()
                self.configureAnimation(isReverseBool: false)
                self.collectionView.refreshControl?.endRefreshing()
            }
    } //handleRefreshControl
    
     func configureAnimation(isReverseBool: Bool) {
         
//         let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
         
         let vectorAnimation = AnimationType.vector(CGVector(dx: 0, dy: 30))
         
        if isReverseBool{
            self.collectionView.performBatchUpdates({
                UIView.animate(views: self.collectionView.orderedVisibleCells,
                               animations: [vectorAnimation],
                               reversed: true,
                               initialAlpha: 1.0,
                               finalAlpha: 0.0,
                               completion: {self.collectionView.reloadData()})
            })
        }else{
            self.collectionView.performBatchUpdates({
                UIView.animate(views: self.collectionView.orderedVisibleCells,
                               animations: [vectorAnimation],
                               initialAlpha: 0.0,
                               finalAlpha: 1.0,
                               completion: nil)
            })
        }
    }
}


extension CatMainListViewController: UICollectionViewDataSourcePrefetching{
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if (indexPath.row + 1 ) / 12 + 1 == catMainListViewModel.currentPage{
                
                catMainListViewModel.scrollDowngetMainListViewModel { item in
                    self.collectionView.reloadData()
                }
            }
        }
    }
}


extension CatMainListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width / 2 - 24
        let size = CGSize(width: width  , height: 232 )
        
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}


extension CatMainListViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CatDetailViewController()
        let id = catMainListViewModel.catIDarr[indexPath.row]
        guard let image = catMainListViewModel.catImageDictionary[id] else {return}
        vc.catmodel = (id,image)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


