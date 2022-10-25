//
//  RequestType.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/25.
//

import Foundation

enum RequestType{
    case breedType(_ breedID: String,
                   _ breedName: String,
                   _ breedImage: String)
}

