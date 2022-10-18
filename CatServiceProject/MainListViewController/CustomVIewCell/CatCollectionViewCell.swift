//
//  CatCollectionViewCell.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/04.
//

import UIKit
import Kingfisher
import SnapKit
import RxCocoa
import RxSwift

final class CatCollectionViewCell: UICollectionViewCell {
    
    private var favoriteAddFlag: Bool?
    private var indexPath: IndexPath?
//    private var favoriteFlagDelegate: FavoriteFlagDataSendDelegate?
    private var image_id: String?
    private var image_URL: String?

    
    private let cellDisposeBag = DisposeBag()
    
    lazy var catItemView: CatItemView = {
        let view = CatItemView()
        view.heartButton.addTarget(self, action: #selector(heartTapped(_:)), for: .touchUpInside)
        return view
    }()
    
    
    var heartChange: ((Bool) -> Void)
    
    var catItemViewObserver: AnyObserver<CatCellModel>
    
    var onChangedHeart: Observable<Bool>
    
    var disposeBag = DisposeBag()


    override init(frame: CGRect) {
        let subject = PublishSubject<CatCellModel>()
        
        catItemViewObserver = subject.asObserver()
        
        
        let outputSubject = PublishSubject<Bool>()
        
        heartChange = { data in outputSubject.onNext(data) }
        
        onChangedHeart = outputSubject

        
        
        super.init(frame: frame)
        
        subject
            .asDriver(onErrorJustReturn: CatCellModel(imageURL: "", catID: "", favorite_id: 0))
            .drive(onNext: {model in
                
                self.catItemView.imageView.kf.setImage(with: URL(string: model.imageURL ))
                self.catItemView.heartButton.heartFlag = model.favoriteFlag
            
            },onDisposed: {print("disposed")}).disposed(by: cellDisposeBag)
        
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    @objc func heartTapped(_ sender: UIButton){
        print("heartTapped")
        self.catItemView.heartButton.heartFlag.toggle()
        heartChange(self.catItemView.heartButton.heartFlag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension CatCollectionViewCell {
 
    
    /// cell 설정 , 오토레이아웃
    func configure() {
        self.backgroundColor = .systemCyan
        self.contentView.backgroundColor = .orange
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.addSubview(catItemView)
        
        catItemView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }

    }
    
}

//        favoriteAddButton.onCompleted = { [weak self] isHighlighedFlag in
//
//            guard let self = self else {print("self failed "); return}
//
//            if isHighlighedFlag == false{
//
//                self.favoriteAddFlag?.toggle()
//                self.favoriteFlagDelegate?.favoriteToggle(self.favoriteAddFlag ?? false, self.indexPath ?? IndexPath(), self.image_URL ?? "",  self.image_id ?? "")
//
//            }
//
//
//
//        }

/// Cell UpdateUI
/// - Parameter catsCellViewModel: catMainViewModel이 가지고 있는 데이터
/// - Parameter indexPath: collectionView 의 IndexPath 위치값
/// - Parameter delegate: CatMainListViewController를 받아와서 데이터 전달
//    func updateUI(_ catsCellViewModel: CatCellModel,_ indexPath: IndexPath, _ delegate: FavoriteFlagDataSendDelegate) {
//        guard let url = catsCellViewModel.imageURL else {print("cell ImageURL ERROR"); return}
//        guard let favoriteFlag = catsCellViewModel.favoriteFlag else {print("favoriteflag ERROR"); return}
//        guard let id = catsCellViewModel.id else {print("id error"); return}
//        self.image_URL = url
//        self.favoriteFlagDelegate = delegate
//        self.imageView.kf.setImage(with: URL(string: url))
//        self.favoriteAddFlag = favoriteFlag
//        self.image_id = id
//        self.indexPath = indexPath
//
//        if self.favoriteAddFlag! {
//
//            self.favoriteAddButton.setImage(starFillImage, for: .normal)
//            self.heartButton.setImage(heartFillImage, for: .normal)
//        }else{
//            self.favoriteAddButton.setImage(starImage, for: .normal)
//            self.heartButton.setImage(heartImage, for: .normal)
//        }
//
