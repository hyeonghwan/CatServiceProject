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
    
    private let catService = CatService()
    
    func getCatBreedsData(){
        catService.getBreedsCategories{ flag,data,error in
            print("getBreedsCategories")
            if flag == true,
               let model = data,
               error == nil{
                print("model count \(model.count)")
                let fetchedData = self.fetchToBreedViewModel(model)
                print("fetchedDataCOunt : \(fetchedData.count)")
                fetchedData.forEach{ model in
                    print(model.breedID)
                    print(model.breedName)
                    print(model.imageModel?.imageID)
                    print(model.imageModel?.imageURL)
                }
            }
        }
        
    }
    
    func getCatListHeaderImage(with completion:
                               @escaping ([UIImage]) -> () ) {
        let catService = CatService()
        

        catService.getImageURL(){ url in
            var count = 0
            
            url.forEach{
                self.downloadImage(with: $0.imageURL ?? ""){ item in
                    count += 1
                    
                    self.headerImageList.append(item)
                    if count == 12 {
                        
                        completion(self.headerImageList)
                    }
                }
            }
        }
    }
    deinit {
        
    }
}
private extension CatBreedsViewModel{
    
    func fetchToBreedViewModel(_ breeds: [Breed]) -> [BreedsViewModel]{
        
       let data = breeds.map{ model in
            guard let breedID = model.id else {return BreedsViewModel()}
            guard let breedName = model.name else {return BreedsViewModel()}
            guard let imageModel = model.imageModel else {return BreedsViewModel()}
           
            return BreedsViewModel(breedID: breedID,
                                   breedName: breedName,
                                   imageModel: imageModel)
        }
        return data
    }
}
struct BreedsViewModel{
    let breedID: String
    let breedName: String
    let imageModel: ImageModel?
    
    init(){
        self.breedID = ""
        self.breedName = ""
        self.imageModel = nil
    }
    
    init(breedID: String, breedName: String, imageModel: ImageModel) {
        self.breedID = breedID
        self.breedName = breedName
        self.imageModel = imageModel
    }
}
