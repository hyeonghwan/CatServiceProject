//
//  MainViewController.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/06.
//

import Foundation
import UIKit
import SnapKit

protocol CustomSegmentedControlDelegate: AnyObject{
    func changeToIndex(index: Int)
}

final class CatBreedsListViewController: UIViewController{
    
    let breedViewModel = CatBreedsViewModel()
    
    lazy var categorySegemts: CategoryView = {
       let segment = CategoryView()
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        breedViewModel.getCatBreedsData()
        
        configure()
        
    }
    func configure() {
        
        self.navigationItem.title = "Cat Service"
        view.backgroundColor = .systemBackground
        
        self.view.addSubview(categorySegemts)
        categorySegemts.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.height.equalTo(130)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
}
