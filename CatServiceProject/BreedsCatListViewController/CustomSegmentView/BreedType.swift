//
//  RequestType.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/25.
//

import Foundation

enum BreedType {
    case breedType(_ breedID: String,
                   _ breedName: String,
                   _ breedImage: String)
}

struct CategoryButtonAndLabel {
    let breedType: BreedType
    let categoryButton: CategoryRoundedButton
    let categoryLabel: CategoryLabel
    
    static func dummyData() -> [BreedType]{
        return [.breedType("abys", "Abyssinian", "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"),
                .breedType("aege", "Aegean", "https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg"),
                .breedType("abob", "American Bobtail", "https://cdn2.thecatapi.com/images/hBXicehMA.jpg"),
                .breedType("acur", "American Curl", "https://cdn2.thecatapi.com/images/xnsqonbjW.jpg"),
                .breedType("asho", "American Shorthair", "https://cdn2.thecatapi.com/images/JFPROfGtQ.jpg"),
                .breedType("awir", "American Wirehair", "https://cdn2.thecatapi.com/images/8D--jCd21.jpg"),
                .breedType("amau", "Arabian Mau", "https://cdn2.thecatapi.com/images/k71ULYfRr.jpg"),]
    }
}
