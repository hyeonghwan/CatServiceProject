//
//  ViewController.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/03.
//

import UIKit
import SnapKit
import Kingfisher
import ViewAnimator

class CatMainListViewController: UIViewController {
    
    private let cellID = "CatCollectionViewCell"
    private var catMainListViewModel = CatMainListViewModel()
    
    var catMainViewModel: CatMainViewModel = CatMainViewModel()
    
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let vectorAnimation = AnimationType.vector(CGVector(dx: 0, dy: 30))
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    /// CollectionView Setting func
    private func configure() {
        self.navigationController?.navigationBar.isHidden = true
        collectionView.prefetchDataSource = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CatCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.refreshControl = self.refreshControl
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = {
       let refControl = UIRefreshControl()
        refControl.attributedTitle = NSAttributedString(string: "", attributes: [
            .font : UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor : UIColor.systemGray.cgColor
        ])
        refControl.tintColor = UIColor.systemGray
        refControl.addTarget(self,
                             action: #selector(handleRefreshControl),
                             for: .valueChanged)
        return refControl
    }()
    
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
     
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print("CatListVIewCOntroller ViewDidLoad called ")
        getViewModelData()
        catMainListViewModel.scrollDowngetMainListViewModel { item in
            self.collectionView.reloadData()
        }
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
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

extension CatMainListViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catMainViewModel.numberOfItemsInSection()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CatCollectionViewCell else {return UICollectionViewCell()}
        
        
        cell.updateUI(catMainViewModel.catsCellViewModels[indexPath.row],indexPath,self)
       
        return cell
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

extension CatMainListViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CatDetailViewController()
        let id = catMainListViewModel.catIDarr[indexPath.row] 
        guard let image = catMainListViewModel.catImageDictionary[id] else {return}
        vc.catmodel = (id,image)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CatMainListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 16
        let height = UIScreen.main.bounds.height / 3 + 50
        return CGSize(width: width  , height: height )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
}


private extension CatMainListViewController {
     func configureAnimation(isReverseBool: Bool) {
        if isReverseBool{
            self.collectionView.performBatchUpdates({
                UIView.animate(views: self.collectionView.orderedVisibleCells,
                               animations: [self.vectorAnimation],
                               reversed: true,
                               initialAlpha: 1.0,
                               finalAlpha: 0.0,
                               completion: {self.collectionView.reloadData()})
            })
        }else{
            self.collectionView.performBatchUpdates({
                UIView.animate(views: self.collectionView.orderedVisibleCells,
                               animations: [self.vectorAnimation],
                               initialAlpha: 0.0,
                               finalAlpha: 1.0,
                               completion: nil)
            })
        }
    }
}

