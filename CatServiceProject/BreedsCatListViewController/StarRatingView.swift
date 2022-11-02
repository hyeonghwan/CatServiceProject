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
    
    override var intrinsicContentSize: CGSize {
        let width = star.frame.width
        let height = star.bounds.height
        
        return CGSize(width: width + 150, height: height)
    }
    private let spacing: CGFloat = 24
    
    lazy var starLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    lazy var star: StarRatingView = {
        let view = StarRatingView()
        let attribute = StarRatingAttribute(type: .rate,
                                            point: 17,
                                            spacing: 5,
                                            emptyColor: .lightGray,
                                            fillColor: .systemYellow,
                                            emptyImage: UIImage(named: "star"),
                                            fillImage: UIImage(named: "star.fill"))
        view.configure(attribute, current: 0, max: 5)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(starLabel)
        self.addSubview(star)
        
        
        
        starLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        starLabel.backgroundColor = .orange
        star.snp.makeConstraints{
            $0.leading.greaterThanOrEqualTo(starLabel.snp.trailing)
            $0.trailing.equalToSuperview().priority(.high)
            $0.centerY.equalToSuperview()
        }
        star.backgroundColor = .blue
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
}
