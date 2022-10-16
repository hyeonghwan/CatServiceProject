//
//  CatCellViewModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/12.
//

import Foundation
import UIKit

struct CatCellModel {
    var favorite_id: Int
    var imageURL: String
    var id: String
    var favoriteFlag: Bool
    
    
    init(imageURL: String, id: String, favoriteFlag: Bool = false, favorite_id : Int){
        self.imageURL = imageURL
        self.id = id
        self.favoriteFlag = favoriteFlag
        self.favorite_id = favorite_id
    }
    
  
}
