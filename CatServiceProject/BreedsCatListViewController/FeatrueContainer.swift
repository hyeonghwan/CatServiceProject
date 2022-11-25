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
    
    
    
    override var intrinsicContentSize: CGSize {
        
        let item = FetureView()
        
        item.setText(text: "test")
        
        let height = item.sizeThatFits(CGSize()).height
        
        let itemSpacing: CGFloat = 24
        
        return CGSize(width: self.maxWidth,
                      height: self.currentHight + height + itemSpacing)
    }
    
    var onData: AnyObserver<[String]>

    var disposeBag = DisposeBag()

    var maxWidth = UIApplication.shared.keyWindow!.frame.width
    
    var currentWidth: CGFloat = 0
    
    var currentHight: CGFloat = 0
    
    var spacing: CGFloat = 12
    
    var featureView: FetureView? {
        didSet{
            guard let featureView = self.featureView else {return}
            
            
                if self.currentWidth == 0  {
                    featureView.frame = CGRect(x: spacing, y: 0,
                                        width: featureView.bounds.width, height: featureView.bounds.height)
                    currentWidth += spacing
                }else {
                    if maxWidth >= (self.currentWidth + featureView.bounds.width + spacing){
                        featureView.frame = CGRect(x: self.currentWidth, y: self.currentHight,
                                            width: featureView.bounds.width, height: featureView.bounds.height)
                    }else {
                        self.currentHight += featureView.bounds.height + spacing
                        self.currentWidth = spacing
                        featureView.frame = CGRect(x: self.currentWidth , y: self.currentHight,
                                            width: featureView.bounds.width, height: featureView.bounds.height)
                    }
                }
                self.currentWidth += featureView.bounds.width + spacing
            
            invalidateIntrinsicContentSize()
            
        }
    }
    
    var fetures: [String] = [] {
        didSet{
            self.fetures.forEach{ string in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    let view = FetureView()
                    
                    self.addSubview(view)
                    
                    view.setText(text: string)
                    
                    view.bounds = CGRect(x: 0, y: 0,
                                         width: view.getItemWidh(),
                                         height: view.getItemHeight() )
                    
                    self.featureView = view
                }
                return
            }
        }
    }
    
    
    override init(frame: CGRect) {
        
        let subject = PublishSubject<[String]>()
        onData = subject.asObserver()
        
        super.init(frame: frame)
        
        subject
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: settingFeatureView(_:))
            .disposed(by: disposeBag)
    }
    
    private func settingFeatureView(_ features : [String]) {
        if self.subviews != [] {
            self.subviews.forEach{
                $0.removeFromSuperview()
                self.currentWidth = 0
                self.currentHight = 0
            }
        }
        self.fetures = features
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
}
