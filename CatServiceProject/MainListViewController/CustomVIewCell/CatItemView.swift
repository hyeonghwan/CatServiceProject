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
    
    lazy var heartButton: HeartButton = {
        let button = HeartButton()
        return button
    }()

    override init(frame: CGRect) {

        super.init(frame: frame)
        
        configure()

    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
   
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        guard isUserInteractionEnabled else { return nil }

        guard !isHidden else { return nil }

        guard alpha >= 0.01 else { return nil }

        guard self.point(inside: point, with: event) else { return nil }

        
        // add one of these blocks for each button in our collection view cell we want to actually work
        if self.heartButton.point(inside: convert(point, to: heartButton), with: event) {
            print("hitTest : \(self.point(inside: point, with: event))")
            return self.heartButton
        }

        return super.hitTest(point, with: event)
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
