//
//  EntityOfFavoriteData.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/12.
//

import Foundation

struct FavouriteResponseWrap {
    let favouritID: Int
    let imageID: String
    var imageURL: String?
    let message: String?
    
    init(_ favouriteID: Int,_ imageID: String,_ imageURL: String?,_ message: String?){
        self.favouritID = favouriteID
        self.imageID = imageID
        self.imageURL = imageURL
        self.message = message
    }
    
    init(_ wrap: Self, imageURL: String){
        self.favouritID = wrap.favouritID
        self.imageID = wrap.imageID
        self.imageURL = imageURL
        self.message = wrap.message
    }
    
    func addImageURL(_ imageURL: String) -> FavouriteResponseWrap{
        return FavouriteResponseWrap(self.favouritID,
                                     self.imageID,
                                     imageURL,
                                     self.message)
    }
    
    init(_ response: EntityOfFavouriteResponse,_ imageID: String){
        self.favouritID = response.id
        self.imageID = imageID
        self.message = response.message
    }
}
struct EntityOfFavouriteResponse: Codable {
    let id: Int
    let message: String?
}


struct FavouriteDeleteResponseWrap{
    let imageID: String
    let message: String
    
    init(imageID: String, message: String) {
        self.imageID = imageID
        self.message = message
    }
}
struct EntityOfDeleteResponse: Codable {
    let message: String?
}

