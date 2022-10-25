//
//  CategoryView.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/25.
//

import Foundation
import SnapKit
import UIKit
import RxSwift

class CategoryView: UIView{
    
    private lazy var containerView: CategoryArrayView = {
      let containerView = CategoryArrayView()
        return containerView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
//    func getObservableRequestType() -> Observable<RequestType> {
//        
//        return self.containerView.onChanged
//        
//    }
    
    private func configue() {
        self.addSubview(containerView)
        
        containerView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview()
        }
    }
}
