//
//  EntityOfFavouriteData.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/13.
//

import Foundation

struct EntityOfFavouriteData: Decodable {
    let id: Int?
    let userID: String?
    let imageID: String?
    let subID: String?
    let day: String?
    let image: ImageIDandURL
    
    enum CodingKeys: String,CodingKey{
        case id
        case userID = "user_id"
        case imageID = "image_id"
        case subID = "sub_id"
        case day = "created_at"
        case image
    }
    struct ImageIDandURL: Decodable{
        let id: String?
        let url: String?
    }
}

//"id": 100071178,
//        "user_id": "idyhog",
//        "image_id": "ol",
//        "sub_id": null,
//        "created_at": "2022-09-12T11:25:28.000Z",
//        "image": {
//            "id": "ol",
//            "url": "https://cdn2.thecatapi.com/images/ol.jpg"
//        }
