//
//  CatBreedHorizontalCell.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/26.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class CatBreedHorizontalCell: UICollectionViewCell{
    
    private lazy var catImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark.app")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.systemCyan.cgColor
        imageView.layer.borderWidth = 3
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configrue()
        
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    func updateUI(_ imageURL: String) {
        self.catImageView.kf.setImage(with: URL(string: imageURL))
    }
    
}
private extension CatBreedHorizontalCell{
    func configrue() {
        self.contentView.addSubview(catImageView)
        
        catImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
    }
}
