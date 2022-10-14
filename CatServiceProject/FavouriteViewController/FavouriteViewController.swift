//
//  FavouriteViewController.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/13.
//

import Foundation
import UIKit
import SnapKit

protocol DeleteFavouriteCellDelegate {
    func deleteFavouriteDataFromCell(_ favourite_id: Int,_ indexPath: IndexPath)
}

class FavouriteViewController: UIViewController {
    
    
    private var favorViewModel : CatFavouriteViewModel = CatFavouriteViewModel()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemCyan
        configure()
        updateCollectionView()
    }
    
    private func updateCollectionView() {
        favorViewModel.favoriteCollectionViewReload = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.collectionView.reloadData()
            }
        }
    }
    
    private func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavouriteCell.self, forCellWithReuseIdentifier: "FavouriteCell")
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}

extension FavouriteViewController: DeleteFavouriteCellDelegate{
    func deleteFavouriteDataFromCell(_ favourite_id: Int,_ indexPath: IndexPath) {
        self.favorViewModel.deleteFavouriteCellData(favourite_id,indexPath)
        
    }
}

extension FavouriteViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorViewModel.numberOfInsection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCell", for: indexPath) as? FavouriteCell else {print("updateUI(_ image: UIImage)"); return UICollectionViewCell()}
        
        cell.updateUI(favorViewModel.favoriteCellModel[indexPath.row],
                      indexPath,
                      self)
        
        return cell
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

