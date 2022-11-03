//
//  FeatrueContainer.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/11/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FeatureContainer: UIView {
    
    var onData: AnyObserver<[String]>

    var disposeBag = DisposeBag()

    var maxWidth = UIApplication.shared.keyWindow!.frame.width
    
    var currentWidth: CGFloat = 0
    
    var currentHight: CGFloat = 0
    
    var spacing: CGFloat = 10
    
    var featureViews: [FetureView] = [] {
        didSet{
            self.featureViews.forEach{ view in
                self.addSubview(view)
                if self.currentWidth == 0  {
                    view.frame = CGRect(x: 0, y: 0,
                                        width: view.bounds.width, height: view.bounds.height)
                }else {
                    if maxWidth >= (self.currentWidth + view.bounds.width + spacing){
                        view.frame = CGRect(x: self.currentWidth, y: self.currentHight,
                                            width: view.bounds.width, height: view.bounds.height)
                    }
                   
                }
                self.currentWidth += view.bounds.width + spacing
//                self.currentHight += view.bounds.height + spacing
            }
        }
    }
    var fetures: [String] = [] {
        didSet{
            self.featureViews = self.fetures.map{ string in
                let view = FetureView(frame: .zero)
                view.featureLabel.text = string
                return view
            }
        }
    }
    
    
    override init(frame: CGRect) {
        
        let subject = PublishSubject<[String]>()
        onData = subject.asObserver()
        
        super.init(frame: frame)
        
        subject
            .subscribe(onNext: {
                self.fetures = $0
            }).disposed(by: disposeBag)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
}
