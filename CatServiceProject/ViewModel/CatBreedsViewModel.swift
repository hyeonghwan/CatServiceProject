//
//  CatListViewModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/08.
//

import Foundation
import Kingfisher
import UIKit

class CatBreedsViewModel: ImageViewModelDelegate {
    // repository -> get entity
    // service -> model -> viewmodel   <- viewcontroller
    var headerImageList: [UIImage] = []
    
    func getCatListHeaderImage(with completion:
                               @escaping ([UIImage]) -> () ) {
        let catService = CatService()
        print("getCatListHeaderImage called")
        catService.getImageURL(){ url in
            var count = 0
            url.forEach{
                self.downloadImage(with: $0.imageURL ?? ""){ item in
                    count += 1
                    self.headerImageList.append(item)
                    if count == 12 {
                        print(self.headerImageList.count)
                        completion(self.headerImageList)
                    }
                }
            }
        }
    }
    deinit {
        print("catListViewModel deinit")
    }
    
    
}
