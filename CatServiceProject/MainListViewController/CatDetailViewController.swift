//
//  CatDetailViewController.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/06.
//

import UIKit
import SnapKit
import Kingfisher

final class CatDetailViewController: UIViewController{
    
    var catmodel: (String,UIImage) = ("",UIImage())
    
    private lazy var catImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = catmodel.1
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
       
    }
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "CatDetailView"
        self.view.addSubview(catImageView)
        catImageView.snp.makeConstraints({make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalToSuperview()
        })
    }
    
    
    
}
