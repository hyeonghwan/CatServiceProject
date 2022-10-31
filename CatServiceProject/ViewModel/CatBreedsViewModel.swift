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
    
    private let catService: CatBreedProtocol = CatService()
    //_ completion: @escaping (([BreedsViewModel]) -> ())
    
    var breedCellModels: [BreedViewModel]? {
        didSet {
            self.breedCellHandler?()
        }
    }
    
    var breedCellHandler: (() -> ())? {
        didSet{
            breedCellHandler?()
        }
    }
    
    func getBVMCategories(_ completion: @escaping () -> ()){
        catService.getBreedCategories{ [weak self] flag,data,error in
            if flag == true,
               let model = data,
               error == nil{
                
                let fetchedData = self?.fetchToBreedViewModel(model)
              
                self?.breedCellModels = self?.toLoopPageDataBinding(fetchedData)
                completion()
            }
        }
    }
    
    func getBVMCatImages(_ breedType: BreedType) {
        print("getBVMCatImages : \(breedType)")
        switch breedType{
        case let .breedType(id, _, _):
            catService.getCatImageByBreed(id){ flag, data, error in
                if flag == true,
                   let model = data,
                   error == nil{
                   print(model)
                }
                
            }
        }
    }
    
    
    func toLoopPageDataBinding(_ data: [BreedViewModel]?) -> [BreedViewModel] {
        var k: [BreedViewModel] = []
        k.append(data!.last!)
        
        data?.forEach{
            k.append($0)
        }
        k.append(data!.first!)
        
        return k
    }
    
    
    func numberOfSection() -> Int {
        return breedCellModels?.count ?? 3
    }
    
    func numberOfPageContolCount() -> Int {
        return self.numberOfSection() - 2
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
    
    func fetchToBreedViewModel(_ breeds: [Breed]) -> [BreedViewModel]{
        
       let data = breeds.map{ model in
            guard let breedID = model.id else {return BreedViewModel()}
            guard let breedName = model.name else {return BreedViewModel()}
            guard let imageModel = model.imageModel else {return BreedViewModel()}
           
            return BreedViewModel(breedID: breedID,
                                   breedName: breedName,
                                   imageModel: imageModel)
        }
        return data
    }
    
    func fetchToBreedViewModle(_ entity: [EntityOfCatData]) -> [BreedViewModel]{
        
        return self.fetchToBreedViewModel([])
    }
}

struct BreedViewModel{
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
