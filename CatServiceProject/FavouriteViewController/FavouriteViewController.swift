//
//  FavouriteViewController.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/13.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

protocol DeleteFavouriteCellDelegate {
    func deleteFavouriteDataFromCell(_ favourite_id: Int,_ indexPath: IndexPath)
}

class FavouriteViewController: UIViewController {
    
    
    var favourtieViewModel : RxFavouriteViewModelType
    
    var disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    init(favourtieViewModel: RxFavouriteViewModelType) {
        
        self.favourtieViewModel = favourtieViewModel
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func loadView() {
        super.loadView()
        let getModelID = GetFavouriteModel("user-123")
        
        favourtieViewModel.onFavouriteData.onNext(getModelID)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutConfigure(collectionView)
        
        setUpBinding()
    }
    
    func setUpBinding() {
        
        favourtieViewModel
            .allFavourites
            .bind(to: collectionView.rx.items(cellIdentifier: FavouriteCell.identify,
                                              cellType: FavouriteCell.self)){
                _, item , cell in
 
                cell.onCellData
                    .onNext(item)
                
                
                cell.deleteDataObservable
                    .map{ _ in return DeleteFavouriteModel(item) }
                    .bind(onNext: self.favourtieViewModel.onDeleteObserver.onNext(_:))
                    .disposed(by: cell.disposeBag)
                
            }.disposed(by: disposeBag )
    }
    
}

