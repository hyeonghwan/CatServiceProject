//
//  CategoryLabel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/25.
//

import Foundation
import UIKit

final class CategoryLabel: UILabel{
    
    
    var buttonfocused: Bool = false {
        didSet{
            self.textColor = buttonfocused ? UIColor.label : UIColor.lightGray
        }
    }
    
    var breedType: BreedType?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        self.textColor = .lightGray
        self.textAlignment = .center
        self.numberOfLines = 2
        
    }
    
    convenience init(frame: CGRect, requestType: BreedType) {
        self.init(frame: frame)
        
        breedType = requestType
        
        switch requestType{
        case let .breedType(_, name, _):
            self.text = name
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
}
