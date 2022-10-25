//
//  ImageModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/11.
//

import Foundation
import UIKit

struct FavouriteImageModel {
    var Image: UIImage?
    var id: String?
    var favoriteFlag: Bool?
    
    
    init(Image: UIImage, id: String, favoriteFlag: Bool = true){
        self.Image = Image
        self.id = id
        self.favoriteFlag = favoriteFlag
    }
    
  
}
