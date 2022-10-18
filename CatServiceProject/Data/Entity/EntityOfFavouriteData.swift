//
//  EntityOfFavouriteData.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/13.
//

import Foundation

struct EntityOfFavouriteData: Decodable {
    let favouriteID: Int?
    let userID: String?
    let imageID: String?
    let subID: String?
    let day: String?
    let imageID_URL: ImageIDandURL
    
    enum CodingKeys: String,CodingKey{
        case favouriteID = "id"
        case userID = "user_id"
        case imageID = "image_id"
        case subID = "sub_id"
        case day = "created_at"
        case imageID_URL = "image"
    }
    struct ImageIDandURL: Decodable{
        let id: String?
        let url: String?
    }
}
