//
//  UIRefreshControl - ex.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/16.
//

import Foundation
import UIKit


extension UIRefreshControl {
    func settingRefreshControl(delegate: CatMainListViewController) {
        
        self.attributedTitle = NSAttributedString(string: "", attributes: [
            .font : UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor : UIColor.systemGray.cgColor
        ])

        self.tintColor = UIColor.systemGray
        self.addTarget(delegate,
                          action: #selector(delegate.handleRefreshControl),
                             for: .valueChanged)

    }
}
