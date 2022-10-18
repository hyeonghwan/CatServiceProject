//
//  RootViewModelType.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/18.
//

import Foundation
import RxSwift

enum VMType{
    case main
    case favourite
}

protocol RootViewModelType {
    var viewType: VMType { get }
    
}
