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
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        return indicator
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
            .asDriver(onErrorJustReturn: CatCellModel(imageURL: "", catID: "", favoriteFlag: false, favouriteID: nil))
            .drive(onNext: {[weak self] model in
                
                self?.catItemView.imageView.kf.setImage(with: URL(string: model.imageURL ))
                self?.catItemView.heartButton.heartFlag = model.favoriteFlag
            
            },onDisposed: {print("disposed")})
            .disposed(by: cellDisposeBag)
        
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    @objc func heartTapped(_ sender: UIButton){
        
        self.catItemView.heartButton.heartFlag.toggle()
        
        self.catItemView.heartButton.heartFlag ?
        sender.toastMessage("즐겨찾기 추가") :
        sender.toastMessage("즐겨찾기 해제")
        
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
        
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.addSubview(catItemView)
        
        catItemView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }

    }
    
}


