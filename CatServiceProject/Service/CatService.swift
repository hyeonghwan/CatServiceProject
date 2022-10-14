//
//  CatService.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/08.
//

import Foundation
import UIKit




class CatService: ImageViewModelDelegate{
    
    private let breedsapiResource: String =  "https://api.thecatapi.com/v1/images/search?format=json&limit=20&breed_id=beng"
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
    
    var serviceModel: [ImageModel] = []
    
    
     func getImageURL(_ onCompleted: @escaping ([CatURLModel]) -> ()){
        Repository.getData(resource: breedsapiResource){ item in
            
            item.forEach{
                self.model.append(CatURLModel(imageURL: $0.imageURL))
            }
            onCompleted(self.model)
        }
    }
    
    
    
    //일정 갯수 이미지를 다운로드 받아서 CatMainListViewModel에 전달
    func countingGetCatMainListDataModel(get count: Int,_ onCompleted: @escaping ([ImageModel]) -> () ){
        Repository.getData(resource: CatListapiResource) { item in
            var index = 0
            item.forEach{ data in
                self.downloadImage(with: data.imageURL ?? ""){ image in
                    index += 1
                    self.serviceModel.append(ImageModel(Image: image , id: data.id ?? "",favoriteFlag: self.favoriteFlag))
                    if count == index{
                        onCompleted(self.serviceModel)
                    }
                }
            }
        }
    }

    
    // image 다운로드받는 순서대로 CatMainListViewModel에 전달
    func directGetCatMainListDataModel(_ onCompleted: @escaping (ImageModel) -> () ){
        Repository.getData(resource: CatListapiResourcePage) { item in
            print(self.CatListapiResourcePage)
            
            item.forEach{ data in
                self.downloadImage(with: data.imageURL ?? ""){ image in
                    let imageModel = ImageModel(Image: image , id: data.id ?? "",favoriteFlag: self.favoriteFlag )
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
