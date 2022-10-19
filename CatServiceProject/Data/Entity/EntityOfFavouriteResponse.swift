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
    let message: String?
    
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
    
}
struct EntityOfDeleteResponse: Codable {
    let message: String?
}

