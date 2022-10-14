//
//  CatBreedsButton.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/07.
//

import Foundation
import UIKit


final class CatBreedsButton: UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGreen
        self.layer.cornerRadius = 24
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        self.titleLabel?.textColor = .white
        self.clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatal error!")
    }
    
    
}
