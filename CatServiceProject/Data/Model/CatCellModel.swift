//
//  CatCellViewModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/12.
//

import Foundation
import UIKit

struct UpdatedHeartModel{
    var catCellModel: CatCellModel
    var changedFavourite: Bool
    
    init(_ catCellModel: CatCellModel,_ changedFavourite: Bool) {
        self.catCellModel = catCellModel
        self.changedFavourite = changedFavourite
    }
    
    static func updateHeart(_ updateHeartModel: UpdatedHeartModel) -> CatCellModel{
        return CatCellModel(updateHeartModel)
    }
    
    static func transFormToFavouitePostModel(_ updatedHeartModel: UpdatedHeartModel) -> PostFavouriteModel {
        return PostFavouriteModel(imageID: updatedHeartModel.catCellModel.catID,
                                  userID: "user-123")
    }
    
    
}

struct CatCellModel {
    var catID: String
    var favouriteID: Int
    var imageURL: String
    var favoriteFlag: Bool
    
    init(){
        self.imageURL = ""
        self.catID = ""
        self.favoriteFlag = false
        self.favouriteID = 0
    }
    
    init(imageURL: String, catID: String, favoriteFlag: Bool = false, favorite_id : Int){
        self.imageURL = imageURL
        self.catID = catID
        self.favoriteFlag = favoriteFlag
        self.favouriteID = favorite_id
    }
    
    init(_ updateHeartModel: UpdatedHeartModel){
        self.catID = updateHeartModel.catCellModel.catID
        self.favouriteID = updateHeartModel.catCellModel.favouriteID
        self.imageURL = updateHeartModel.catCellModel.imageURL
        self.favoriteFlag = updateHeartModel.changedFavourite
    }
    
    init(catCellModel: CatCellModel,_ entity: FavouriteResponseWrap){
        self.catID = catCellModel.catID
        self.imageURL = catCellModel.imageURL
        self.favoriteFlag = true
        self.favouriteID = entity.favouritID
    }
    
}
