//
//  FavouritePostModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/17.
//

import Foundation

protocol POSTMODEL {
    var body: Dictionary<String,String> {get set}
    var imageID: String { get }
}

struct PostFavouriteModel: POSTMODEL {
    
    let imageID: String
    let userID: String
    
    var body: [String : String] = [:]
    
    init(imageID: String, userID: String) {
        self.imageID = imageID
        self.userID = userID
        self.body = ["image_id" : imageID, "sub_id" : userID]
    }

}

protocol GETMOMEL {
    var subID: [String : String] { get }
}

struct GetFavouriteModel: GETMOMEL {
    var subID: [String : String]
    init(_ subIDValue: String){
        self.subID = ["sub_id" : subIDValue]
    }
}


protocol DELETEMODEL {
    var favouriteID: Int { get }
    var imageID: String { get }
}

struct getFavouriteModel: DELETEMODEL {
    var favouriteID: Int
    var imageID: String
}
