//
//  ViewController.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/03.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class CatMainListViewController: UIViewController {

    var catMainListViewModel = CatMainListViewModel()
    
    var catMainViewModel: CatMainViewModel = CatMainViewModel()
    
    var disposeBag = DisposeBag()
    
    lazy var collectionView: UICollectionView = {
        return UICollectionView.collectionConfigure()
    }()
    
    /// CollectionView Setting func
    
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.settingRefreshControl(delegate: self)
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutConfigure()
        
        catMainViewModel.onDataObserver.onNext(())
        
        catMainListViewModel.scrollDowngetMainListViewModel { item in
            self.collectionView.reloadData()
        }
        setUpBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpBinding() {
        
        catMainViewModel
            .allCatData
            .bind(to: self.collectionView.rx.items(cellIdentifier: CatCollectionViewCell.identify,
                                                   cellType: CatCollectionViewCell.self)){
                index , cellModel , cell in
                
                cell.catItemView.catItemViewObserver.onNext(cellModel)
                
            }.disposed(by: disposeBag)
            
    }
    
    
    /// catMainVIewModel -> getCats호출 -> 데이터 받아오면 -> reloadCollectionView
    private func getViewModelData() {
        catMainViewModel.getCats()
        
        catMainViewModel.reloadCollectionView = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.collectionView.reloadData()
            }
        }
    }
}



extension CatMainListViewController: FavoriteFlagDataSendDelegate{
    
    
    /// Send Data to CatMainViewModel
    /// - Parameters:
    ///   - favorite: favoriteButton add or not
    ///   - id: image id
    ///   - indexPath: cell 위치
    ///   - image_URL: Image URL
    func favoriteToggle(_ favorite: Bool, _ indexPath: IndexPath,_ image_URL: String,_ image_id: String) {
        catMainViewModel.postFavoriteToggleData(favorite, image_id,image_URL, indexPath)
    }
}






