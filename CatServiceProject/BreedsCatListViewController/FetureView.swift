//
//  ContryView.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/11/03.
//

import UIKit
import SnapKit


class FetureView: UIView {
    
    override var intrinsicContentSize: CGSize {
        let spacing: CGFloat = 24
        let width = featureLabel.bounds.width + spacing
        
        
        
        return CGSize(width: featureLabel.bounds.width + spacing
                      , height: featureLabel.bounds.height + spacing)
    }
    
     lazy var featureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .systemGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemCyan
        self.layer.cornerRadius = 12
        
        self.addSubview(featureLabel)
        
        featureLabel.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
}
