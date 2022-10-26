//
//  Cell + ex.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/16.
//

import Foundation

protocol IdentifiableProtocol {
    static var identify: String { get }
}
extension IdentifiableProtocol{
    static var identify: String {
        return String(describing: Self.self)
    }
}

extension CatCollectionViewCell: IdentifiableProtocol {}

extension FavouriteCell: IdentifiableProtocol {}

extension CatBreedHorizontalCell: IdentifiableProtocol {}
