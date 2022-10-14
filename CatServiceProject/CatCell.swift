//
//  CatCell.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/04.
//

import Foundation
import UIKit
import SnapKit

final class CatCell: UICollectionViewCell{
    private lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
