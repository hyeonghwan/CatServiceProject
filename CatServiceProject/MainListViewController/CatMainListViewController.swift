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
    
    var catMainViewModel: CatMainViewModel
    
    var disposeBag = DisposeBag()
    
    init( catMainViewModel: CatMainViewModel) {
        self.catMainViewModel = catMainViewModel
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        return UICollectionView.collectionConfigure()
    }()

    
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
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: CatCollectionViewCell.identify,
                                                   cellType: CatCollectionViewCell.self)){
                index , item , cell in
                
                cell.catItemViewObserver.onNext(item)
                
                cell.onChangedHeart
                    .map{ heartFlag in UpdatedHeartModel(item, heartFlag)}
                    .do(onNext: {data in })
                    .bind(to: self.catMainViewModel.favouriteHeartObserver)
                    .disposed(by: cell.disposeBag )
                
            }.disposed(by: disposeBag)
    }
}



