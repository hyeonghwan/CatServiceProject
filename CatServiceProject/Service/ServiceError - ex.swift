//
//  Error - ex.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/16.
//

import Foundation

enum ServiceErrorCode: Int {
    case jsonDecodingError = 1100
}

extension NSError {
    static func serviceError(_ code: ServiceErrorCode) -> NSError {
        return NSError(domain: String(describing: code.self), code: code.rawValue)
    }
}
