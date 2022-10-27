//
//  CatData.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/03.
//

import Foundation


// MARK: - WelcomeElement
struct EntityOfCatData: Codable {
    let breeds: [Breed]
    let categories: [Category]?
    let id: String?
    let imageURL: String?
    let width, height: Int?
    
    enum CodingKeys: String,CodingKey {
        case breeds
        case categories
        case id
        case imageURL = "url"
        case width
        case height
    }
}

// MARK: - Breed
struct Breed: Codable {
    let weight: Weight?
    let id, name: String?
    let cfaURL: String?
    let vetstreetURL: String?
    let vcahospitalsURL: String?
    let temperament, origin, countryCodes, countryCode: String?
    let breedDescription, lifeSpan: String?
    let indoor, lap: Int?
    let altNames: String?
    let adaptability, affectionLevel, childFriendly, dogFriendly: Int?
    let energyLevel, grooming, healthIssues, intelligence: Int?
    let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int?
    let experimental, hairless, natural, rare: Int?
    let rex, suppressedTail, shortLegs: Int?
    let wikipediaURL: String?
    let hypoallergenic: Int?
    let referenceImageID: String?
    let imageModel: ImageModel?
    

    
    enum CodingKeys: String, CodingKey {
        case weight, id, name
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case temperament, origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case breedDescription = "description"
        case lifeSpan = "life_span"
        case indoor, lap
        case altNames = "alt_names"
        case adaptability
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation, experimental, hairless, natural, rare, rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case wikipediaURL = "wikipedia_url"
        case hypoallergenic
        case referenceImageID = "reference_image_id"
        case imageModel = "image"
    }
}

struct ImageModel: Codable {
    let imageID: String
    let width: Int
    let height: Int
    let imageURL: String
    
    enum CodingKeys: String,CodingKey{
        case imageID = "id"
        case width
        case height
        case imageURL = "url"
    }
}
// MARK: - Weight
struct Weight: Codable {
    let imperial, metric: String
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
}

