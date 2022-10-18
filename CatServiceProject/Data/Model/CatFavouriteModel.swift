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
        self.favourite_id = 0
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
    
}
//struct EntityOfFavouriteData: Decodable {
//    let id: Int?
//    let userID: String?
//    let imageID: String?
//    let subID: String?
//    let day: String?
//    let image: ImageIDandURL
//
//    enum CodingKeys: String,CodingKey{
//        case id
//        case userID = "user_id"
//        case imageID = "image_id"
//        case subID = "sub_id"
//        case day = "created_at"
//        case image
//    }
//    struct ImageIDandURL: Decodable{
//        let id: String?
//        let url: String?
//    }
//}
