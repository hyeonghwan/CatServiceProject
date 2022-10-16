//
//  CatItemView.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/16.
//

import Foundation
import SnapKit
import UIKit
import RxCocoa
import RxSwift


final class CatItemView: UIView {
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var buttonContainerview: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var heartButton: HeartButton = {
        let button = HeartButton()
        return button
    }()
    
    var catItemViewObserver: AnyObserver<CatCellModel>
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        
        let subject = PublishSubject<CatCellModel>()
        
        catItemViewObserver = subject.asObserver()
        
        super.init(frame: frame)
        
        configure()
        
        subject
            .asDriver(onErrorJustReturn: CatCellModel(imageURL: "", id: "", favorite_id: 0))
            .drive(onNext: {model in
            
            
                    self.imageView.kf.setImage(with: URL(string: model.imageURL ))
                    self.heartButton.heartObserver.onNext(model.favoriteFlag )
                
               
            }).disposed(by: disposeBag)
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    
}
private extension CatItemView {
    func configure() {
        self.addSubview(imageView)
        imageView.addSubview(buttonContainerview)
        buttonContainerview.addSubview(heartButton)
        
        
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        buttonContainerview.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(40)
        }
        
        heartButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        
    }
}
