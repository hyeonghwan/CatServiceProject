//
//  FavouriteModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/13.
//

import Foundation


struct CatFavouriteModel {
    let favourite_id: Int?
    let imageID: String?
    let imageURL: String?
    
    
    init(){
        self.favourite_id = nil
        self.imageID = ""
        self.imageURL = ""
    }
    
    init(favourite_id: Int?, imageID: String?, imageURL: String?) {
        self.favourite_id = favourite_id
        self.imageID = imageID
        self.imageURL = imageURL
    }
    
    init(_ catCellModel: CatCellModel){
        self.favourite_id = catCellModel.favouriteID
        self.imageID = catCellModel.catID
        self.imageURL = catCellModel.imageURL
    }
    
    init(_ favouriteResponseWrap: FavouriteResponseWrap){
        self.favourite_id = favouriteResponseWrap.favouritID
        self.imageID = favouriteResponseWrap.imageID
        self.imageURL = favouriteResponseWrap.imageURL
    }
}

