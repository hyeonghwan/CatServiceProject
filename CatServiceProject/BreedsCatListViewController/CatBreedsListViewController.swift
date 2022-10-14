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
    weak var delegete: CustomSegmentedControlDelegate?
    private lazy var button: AnimationButton = {
        let button = AnimationButton( primaryAction: UIAction(handler: { _ in 
            
        }))
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
      }()
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("MainViewController ViewDidLoad called")
//        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.title = "Cat Service"
        view.backgroundColor = .systemBackground
        let customSegement = CustomSegmentControl(frame: .zero)
        customSegement.backgroundColor = .clear
        view.addSubview(customSegement)
        self.view.addSubview(self.button)
           self.button.translatesAutoresizingMaskIntoConstraints = false
           self.button.widthAnchor.constraint(equalToConstant: 120).isActive = true
           self.button.heightAnchor.constraint(equalToConstant: 120).isActive = true
           
           self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
           self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        customSegement.snp.makeConstraints{make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
    }
    
}
