//
//  StarRatingView.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/31.
//

import UIKit
import MGStarRatingView
import SnapKit

class StarView: UIView{
    
    private lazy var star: StarRatingView = {
        let view = StarRatingView()
        let attribute = StarRatingAttribute(type: .rate,
                                            point: 30,
                                            spacing: 10,
                                            emptyColor: .lightGray,
                                            fillColor: .systemYellow,
                                            emptyImage: UIImage(named: "star"),
                                            fillImage: UIImage(named: "star.fill"))
        view.configure(attribute, current: 3, max: 5)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(star)
        star.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
}
