//
//  MainCatListViewModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/11.
//

import Foundation
import UIKit

final class CatMainListViewModel {
    
    private var catList: [CatMainListDataModel] = []
    var currentPage = 0
    
    
    var catImageListModel : [FavouriteImageModel] = []
    var catImageModel: FavouriteImageModel?
    
    var catImageDictionary: [String : UIImage] = [:]
    var catIDarr: [String] = []
    var flag: [Bool] = []
    
    init() {
        print("CatMainListViewModel init")
        
    }
    
    // 위로스크롤 이벤트 발생시(refreshing control) 일정갯수를 입력시 이미지 한번에 리턴
    func scrollRefreshingGetImage(count: Int,completion: @escaping ([String]) -> ()) {
        let catService = CatService()
        currentPage += 1
        catService.countingGetCatMainListDataModel(get: count){ item in
            
            item.forEach{
                self.catImageDictionary[$0.id ?? ""] = $0.Image ?? UIImage()
                self.catIDarr.append($0.id ?? "")
                self.flag.append($0.favoriteFlag ?? false)
            }
            completion(self.catIDarr)
        }
    }
    
    // 아래로 스크롤시 페이지 추가하면서 데이터 추가
    func scrollDowngetMainListViewModel(completion: @escaping ([String]) -> ()) {
        let catService = CatService(page: currentPage)
        currentPage += 1
        catService.directGetCatMainListDataModel{ model in
            
            guard let id = model.id else
                {print("scrollDowngetMainListViewModel id error"); return}
            guard let image = model.Image else {print("scrollDowngetMainListViewModel image error"); return}
            guard let flag = model.favoriteFlag else {print("scrollDowngetMainListViewModel flag error"); return}
           
            self.catImageDictionary[id] = image
            self.catIDarr.append(id)
            self.flag.append(flag)
            
            self.catImageModel = FavouriteImageModel(Image: image, id: id, favoriteFlag: flag)
            guard let catImageModel = self.catImageModel else { print("scrollDowngetMainListViewModel error"); return}
            self.catImageListModel.append(catImageModel)
            
            completion(self.catIDarr)
            
        }
    }
}


