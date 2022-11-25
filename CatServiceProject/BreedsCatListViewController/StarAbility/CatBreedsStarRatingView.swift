//
//  CatBreedsConatinerView.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/11/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CatBreedsStarRatingView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private let ratingName: [String] = ["adaptability","affectionLevel"]
    
    
    lazy var starAbilityView: StarAbilityAll = {
       let view = StarAbilityAll()
        return view
    }()
    
    private lazy var con: UIView = {
        let view = UIView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
        
    }
    
    private func configure() {
        
        self.addSubview(starAbilityView)
        
        starAbilityView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(12)
            
        }
        
       
    }
    
    
    
}
