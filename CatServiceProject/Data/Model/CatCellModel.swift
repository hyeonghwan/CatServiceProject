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
    
    static func transFormToFavouitePostModel(_ updatedHeartModel: UpdatedHeartModel) -> POSTMODEL {
        
            return PostFavouriteModel(imageID: updatedHeartModel.catCellModel.catID,
                                      userID: "user-123")
    }
    
    static func getToDeleteFavouriteID(_ updatedHeartModel: UpdatedHeartModel) -> DELETEMODEL{
        print(updatedHeartModel)
        guard updatedHeartModel.catCellModel.favouriteID != nil else {return DeleteFavouriteModel()}
        
        return  DeleteFavouriteModel(favouriteID: updatedHeartModel.catCellModel.favouriteID ?? 0,
                                     imageID: updatedHeartModel.catCellModel.catID)
    }
    
    
}

struct CatCellModel {
    var catID: String
    var favouriteID: Int?
    var imageURL: String
    var favoriteFlag: Bool
    
    init(){
        self.imageURL = ""
        self.catID = ""
        self.favoriteFlag = false
        self.favouriteID = nil
    }
    
    init(imageURL: String, catID: String, favoriteFlag: Bool = false, favouriteID : Int?){
        self.imageURL = imageURL
        self.catID = catID
        self.favoriteFlag = favoriteFlag
        self.favouriteID = favouriteID
    }
    
    init(_ updateHeartModel: UpdatedHeartModel){
        self.catID = updateHeartModel.catCellModel.catID
        self.favouriteID = updateHeartModel.catCellModel.favouriteID
        self.imageURL = updateHeartModel.catCellModel.imageURL
        self.favoriteFlag = updateHeartModel.changedFavourite
    }
    
    init(catCellModel: CatCellModel,_ favouriteResponseWrapEntity: FavouriteResponseWrap){
        self.catID = catCellModel.catID
        self.imageURL = catCellModel.imageURL
        self.favoriteFlag = true
        self.favouriteID = favouriteResponseWrapEntity.favouritID
    }
    func addFavourite(_ favouriteModel: FavouriteResponseWrap) -> CatCellModel{
        return CatCellModel(imageURL: self.imageURL,
                            catID: favouriteModel.imageID,
                            favoriteFlag: true,
                            favouriteID: favouriteModel.favouritID)
    }
    
    init(catCellModel: CatCellModel,_ deletedModel: FavouriteDeleteResponseWrap){
        self.catID = catCellModel.catID
        self.favoriteFlag = false
        self.favouriteID = nil
        self.imageURL = catCellModel.imageURL
    }
    
    func deleteFavourite(_ deletedModel: FavouriteDeleteResponseWrap) -> CatCellModel {
        return CatCellModel(imageURL: self.imageURL,
                            catID: deletedModel.imageID,
                            favoriteFlag: false,
                            favouriteID: nil)
    }
    
//    
//    init(updatedHeartModel: UpdatedHeartModel){
//        self.catID = updatedHeartModel.catCellModel.catID
//        self.imageURL = updatedHeartModel.catCellModel.imageURL
//        self.favouriteID = nil
//        self.favoriteFlag = updatedHeartModel.catCellModel.favoriteFlag
//    }
    
    
    
}
