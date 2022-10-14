//
//  CatUpLoadModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/15.
//

import Foundation


struct CatLodedResponseModel: Codable{
    let imageID: String?
    let imageURL: String?
    let subID: String?
    let width: Int?
    let height: Int?
    let originalFilename: String?
    let pending: Int?
    let approved: Int?
    
    enum CodingKeys: String,CodingKey{
        case imageID = "id"
        case imageURL = "url"
        case subID = "sub_id"
        case width
        case height
        case originalFilename = "original_filename"
        case pending
        case approved
        
    }
    
}

//{
//    "id": "hi1rTyo5e",
//    "url": "https://cdn2.thecatapi.com/images/hi1rTyo5e.jpg",
//    "sub_id": "user-123",
//    "width": 195,
//    "height": 130,
//    "original_filename": "cat3.jpeg",
//    "pending": 0,
//    "approved": 1
//}
