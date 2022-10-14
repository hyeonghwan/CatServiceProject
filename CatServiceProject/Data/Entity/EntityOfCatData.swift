//
//  CatData.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/03.
//

import Foundation

struct EntityOfCatData: Codable{
    
    var breeds: [Breeds]?
    var id: String?
    var height: Int?
    var width: Int?
    var imageURL: String?
    
    
    enum CodingKeys: String, CodingKey{
        case breeds = "breeds"
        case id = "id"
        case height = "height"
        case width = "width"
        case imageURL = "url"
    }
    struct Breeds: Codable{
        let description: String?
        let altName: String?
        
        enum Codingkeys: String, CodingKey{
            case description = "description"
            case altName = "alt_names"
        }
    }
    
}
