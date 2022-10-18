//
//  Error - ex.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/16.
//

import Foundation


// HTTP Method fail enum Type
enum REPErrorCode: Int{
    case bodyError = 1000
    case upLoadingError = 1001
    case postErorr = 1002
    case postDataResultEmptyError = 1003
    case HTTPURLResponseError = 1004
}


extension Result{
    static func resultError(_ message: String) -> Result<Data,Error> {
        return .failure(NSError.createError(message))
    }
}


extension NSError {
    static func createError(_ message: String) -> NSError {
        return NSError(domain: message, code: 0)
    }
}


extension String {
    
    static func toString(_ code: REPErrorCode) -> String {
        return "Message: \(code.self) | statusCode:  \(code.rawValue)"
    }
    
    static func toString(_ code: Int) -> String {
        return "Message: HTTPerror | statusCode:  \(code)"
    }
}
