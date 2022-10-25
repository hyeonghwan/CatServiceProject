//
//  CategoryRoundedButton.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/25.
//

import Foundation
import UIKit
import Kingfisher

final class CategoryRoundedButton: UIButton{
    
    
    override var isSelected: Bool {
        didSet{
            isSelected ? selectedConfigure() : baseConfigure()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        self.addTarget(self, action: #selector(categorybuttonTapped), for: .touchUpInside)
    }
    convenience init(frame: CGRect,requestType: RequestType) {
        self.init(frame: frame)
        
        switch requestType{
        case let .breedType(_, _, imageURL):
            
            self.kf.setImage(with: URL(string: imageURL), for: .normal)
        }
        
        self.clipsToBounds = true

        self.imageView?.contentMode = .scaleAspectFit
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatal error!")
    }
}

extension CategoryRoundedButton{
    
    func configure() {
        self.backgroundColor = .systemGray4
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.cornerRadius = 30
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        self.titleLabel?.textColor = .label
        
    }
    
    @objc func categorybuttonTapped(_ sender: UIButton){
        let vibrate = UIImpactFeedbackGenerator(style: .light)
        vibrate.impactOccurred()
    }
    
    func baseConfigure() {
        self.layer.borderWidth = 0
    }
    
    func selectedConfigure() {
        self.layer.borderWidth = 5
    }
}

