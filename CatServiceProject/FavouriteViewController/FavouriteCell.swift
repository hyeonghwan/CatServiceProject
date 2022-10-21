//
//  FavouriteCell.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/13.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SnapKit

class FavouriteCell: UICollectionViewCell{
    
    private var deleteDelegate: DeleteFavouriteCellDelegate?
    private var favourite_id: Int?
    private var indexPath: IndexPath?
    
    var onCellData: AnyObserver<CatFavouriteModel>
    
    var deleteDataObservable: Observable<Void>
    
    
    var cellDisposeBag = DisposeBag()
    
    var disposeBag = DisposeBag()
    
    var deleteCompletion: (() -> Void)?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var deleteButton: AnimationButton = {
       let button = AnimationButton(primaryAction: deleteAction)
        button.isEnabled = true
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .systemGray
        button.backgroundColor = .systemGreen
        return button
    }()
    
    private lazy var deleteAction: UIAction = UIAction(handler: { [unowned self] _ in
        deleteCompletion?()
    })
   
    
    override init(frame: CGRect) {
        
        
        let cellDataPipe = PublishSubject<CatFavouriteModel>()
        
        onCellData = cellDataPipe.asObserver()
        
        let deletePipe = PublishSubject<Void>()
      
        deleteCompletion = { deletePipe.onNext(()) }
        
        
        deleteDataObservable = deletePipe
        
        
        super.init(frame: frame)
        
        cellDataPipe
            .asDriver(onErrorJustReturn: CatFavouriteModel())
            .drive(onNext: { [weak self] model in
                
                if let urlString = model.imageURL{
                    self?.imageView.kf.setImage(with: URL(string: urlString))
                }
            }).disposed(by: cellDisposeBag)
        
        
        configureCell()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    required init?(coder: NSCoder) {
        fatalError("FavouriteCell required init error")
    }
    
    func updateUI(_ favoriteCellModel: CatFavouriteModel,
                  _ indexPath: IndexPath,
                  _ deleteDelegate: DeleteFavouriteCellDelegate) {
        self.imageView.kf.setImage(with: URL(string: favoriteCellModel.imageURL ?? ""))
        self.favourite_id = favoriteCellModel.favourite_id
        self.indexPath = indexPath
        self.deleteDelegate = deleteDelegate
        
    }
}

private extension FavouriteCell {
    private func configureCell() {
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(deleteButton)
        self.imageView.backgroundColor = .systemGreen
        
        imageView.snp.makeConstraints{
            $0.top.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(deleteButton.snp.top)
        }
        deleteButton.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.centerX.equalTo(imageView.snp.centerX)
            $0.width.height.equalTo(40)
             
            
            //later posting issue
            $0.bottom.equalToSuperview()
        }
    }
}

//override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//
//    guard isUserInteractionEnabled else { return nil }
//
//    guard !isHidden else { return nil }
//
//    guard alpha >= 0.01 else { return nil }
//
//
//
//    guard self.point(inside: point, with: event) else { return nil }
//
//
//    // add one of these blocks for each button in our collection view cell we want to actually work
//    if self.deleteButton.point(inside: convert(point, to: deleteButton), with: event) {
//        return self.deleteButton
//    }
//
//    return super.hitTest(point, with: event)
//}
