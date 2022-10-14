//
//  ImageViewModelDelegate.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/11.
//

import Foundation
import UIKit
import Kingfisher

protocol ImageViewModelDelegate {
    func downloadImage(with urlString : String ,
                       downloadCompleted: @escaping (UIImage) ->() )
}

extension ImageViewModelDelegate {
    func downloadImage(with urlString : String ,
                       downloadCompleted: @escaping (UIImage) ->() ){
        guard let url = URL(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                downloadCompleted(value.image)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

