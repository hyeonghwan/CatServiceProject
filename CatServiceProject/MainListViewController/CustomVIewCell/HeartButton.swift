//
//  HeartButton.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/16.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HeartButton: UIButton {
    
    private var heartFlag: Bool = false {
        didSet {
            heartFlag ?
            self.setImage(UIImage(named: "Heart.fill"), for: .normal)
            : self.setImage(UIImage(named: "Heart"), for: .normal)
        }
    }
    
    var heartObserver: AnyObserver<Bool>
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        let subject = PublishSubject<Bool>()
        
        heartObserver = subject.asObserver()
        
        super.init(frame: frame)
        
        subject
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { favouriteFlag in
                favouriteFlag ?
                self.setImage(UIImage(named: "Heart.fill"), for: .normal)
                : self.setImage(UIImage(named: "Heart"), for: .normal)
            }).disposed(by: disposeBag)
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    private func configure() {
        self.backgroundColor = .white
        self.setImage(UIImage(named: "Heart.fill"), for: .normal)
    }
}
