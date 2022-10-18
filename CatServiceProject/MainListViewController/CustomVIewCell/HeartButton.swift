//
//  HeartButton.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/16.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HeartButton: UIButton {
    
    var heartFlag: Bool = false {
        didSet {
            heartFlag ?
            self.setImage(UIImage(named: "Heart.fill"), for: .normal)
            : self.setImage(UIImage(named: "Heart"), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        
        
        super.init(frame: frame)
        
        configure()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    private func configure() {
        self.backgroundColor = .white
        self.setImage(UIImage(named: "Heart.fill"), for: .normal)
    }
}
