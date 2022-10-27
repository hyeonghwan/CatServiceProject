//
//  CatService.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/08.
//

import Foundation
import UIKit


protocol CatBreedProtocol {
    func getBreedCategories(_ completion: @escaping ((Bool,[Breed]?,Error?) -> ()))
    func getCatImageByBreed(_ breedID: String, completion: @escaping (Bool,[EntityOfCatData]?,Error?) -> ())
}

class CatService: ImageViewModelDelegate,CatBreedProtocol{
    
    private let breedBangID: String =  "https://api.thecatapi.com/v1/images/search?format=json&limit=20&breed_id=beng"
    
    private let breedsCategories: String =
    "https://api.thecatapi.com/v1/breeds"
    
    private let breedCatImageResource: String =
    "https://api.thecatapi.com/v1/images/search"
    
    private var CatListapiResourcePage: String
    private var CatListapiResource: String = "https://api.thecatapi.com/v1/images/search?format=json&limit=12"
    private var favoriteFlag = true
    init() {
        self.CatListapiResourcePage = ""
    }
    init(page: Int){
        self.CatListapiResourcePage = "https://api.thecatapi.com/v1/images/search?format=json&limit=12&page=\(page)"
    }
    
    var model: [CatURLModel] = []
    
    var mainListImageModel: [CatMainListDataModel] = []
    
    var serviceModel: [FavouriteImageModel] = []
    
    
     func getImageURL(_ onCompleted: @escaping ([CatURLModel]) -> ()){
        Repository.getData(resource: breedBangID){ item in
            item.forEach{
                self.model.append(CatURLModel(imageURL: $0.imageURL))
            }
            onCompleted(self.model)
        }
    }
    
    func getBreedCategories(_ completion: @escaping ((Bool,[Breed]?,Error?) -> ())){
        
        let breedparams = [ "limit" : "8", "page" : "0"]
        
        Repository().GET(url: breedsCategories,
                         params: breedparams,
                         httpHeader: .application_json){ result in
            switch result{
            case let .success(data):
                do {
                    let model = try JSONDecoder().decode([Breed].self, from: data)
                   
                    completion(true, model, nil)
                    
                }catch{
                    
                    completion(false, nil, NSError.serviceError(ServiceErrorCode.jsonDecodingError))
                }
            case let .failure(err):
                print(err)
            }
        }
    }
    
//    breed_ids=beng&limit=8&page=0
    
    func getCatImageByBreed(_ breedID: String, completion: @escaping (Bool,[EntityOfCatData]?,Error?) -> ()) {
        let params = [ "breed_ids" : breedID ,
                       "limit" : "8",
                       "page" : "0"]
        
        Repository().GET(url: breedCatImageResource,
                         params: params,
                         httpHeader: .application_json){ result in

            switch result{
            case let .success(data):
                do {
                    let model = try JSONDecoder().decode([EntityOfCatData].self, from: data)
                    completion(true, model, nil)
                }catch{
                    completion(false, nil, error)
                }
            case let .failure(err):
                completion(false, nil, err)
            }
        }
    }
    
    
    
    //일정 갯수 이미지를 다운로드 받아서 CatMainListViewModel에 전달
    func countingGetCatMainListDataModel(get count: Int,_ onCompleted: @escaping ([FavouriteImageModel]) -> () ){
        Repository.getData(resource: CatListapiResource) { item in
            var index = 0
            item.forEach{ data in
                self.downloadImage(with: data.imageURL ?? ""){ image in
                    index += 1
                    self.serviceModel.append(FavouriteImageModel(Image: image , id: data.id ?? "",favoriteFlag: self.favoriteFlag))
                    if count == index{
                        onCompleted(self.serviceModel)
                    }
                }
            }
        }
    }

    
    // image 다운로드받는 순서대로 CatMainListViewModel에 전달
    func directGetCatMainListDataModel(_ onCompleted: @escaping (FavouriteImageModel) -> () ){
        Repository.getData(resource: CatListapiResourcePage) { item in
            print(self.CatListapiResourcePage)
            
            item.forEach{ data in
                self.downloadImage(with: data.imageURL ?? ""){ image in
                    let imageModel = FavouriteImageModel(Image: image , id: data.id ?? "",favoriteFlag: self.favoriteFlag )
                    self.serviceModel.append(imageModel)
                    
                    onCompleted(imageModel)
                }
            }
        }
    }
    
    deinit {
        print("catService deinit")
    }
}
//format=json&limit=12

    


//func getCatMainListDataModel(_ onCompleted: @escaping ([CatMainListDataModel]) -> () ){
//    Repository.getData(resource: CatListapiResource) { item in
//        item.forEach{
//            self
//                .mainListImageModel
//                .append(CatMainListDataModel(id: $0.id, catImageURL: $0.imageURL))
//        }
//        onCompleted(self.mainListImageModel)
//    }
//}



//func getCatMainListDataModel2(get count: Int,_ onCompleted: @escaping ([ImageModel]) -> () ){
//    Repository.getData(resource: CatListapiResource) { item in
//        var index = 0
//        item.forEach{ data in
//            self.downloadImage(with: data.imageURL ?? ""){ image in
//                index += 1
//                self.serviceModel.append(ImageModel(Image: image , id: data.id ?? "" ))
//                if count == index{
//                    onCompleted(self.serviceModel)
//                }
//            }
//        }
//    }
//}
