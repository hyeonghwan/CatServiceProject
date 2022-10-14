//
//  CatFavouriteViewModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/13.
//

import Foundation



class CatFavouriteViewModel {
    private var catService: CatServiceProtocol
    
    var favoriteCollectionViewReload: (() -> Void)?
    
    var favoriteCellModel = [CatFavouriteModel]() {
        didSet{
            favoriteCollectionViewReload?()
        }
    }
    
    init(_ catService: CatServiceProtocol = CatService2() ) {
        self.catService = catService
        self.catService.getFavouriting{ success,data,error in
            if success, let favorites = data {
                self.fetchData(favorites)
            }else{
                print(error!)
            }
        }
        notificationAddObserver()
    }
    
    func numberOfInsection() -> Int {
        return self.favoriteCellModel.count
    }
    
    func deleteFavouriteCellData(_ favourite_id: Int,_ indexPath: IndexPath) {
        
        self.favoriteCellModel.remove(at: indexPath.row)
        self.catService.deleteFavouriting(favourite_id: favourite_id)
        
        //notify MainView to change button if have favouriteData
        NotificationCenter.default.post(name: Notification.Name.deleteActInFC,
                                        object: nil,
                                        userInfo: ["favourite_id" : favourite_id])
    }
}

private extension CatFavouriteViewModel{
    
    
    /// FetchData - 서버에서 가져온 데이터를 Cell에 보여줄 데이터로 변형
    /// - Parameter favorEntities: 서버에서 가져온 Data
    func fetchData(_ favorEntities: [EntityOfFavouriteData]){
        for favor in favorEntities {
            guard let id = favor.id else {print("CatFavouriteViewModel id error"); return}
            guard let imageID = favor.image.id else {print("CatFavouriteViewModel imageID error"); return}
            guard let imagURL = favor.image.url else {print("CatFavouriteViewModel imageURL error"); return}
            favoriteCellModel.append(CatFavouriteModel(favourite_id: id,imageID: imageID, imageURL: imagURL))
        }
    }
    
    func notificationAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(addDataToCellModel(notification: )), name: Notification.Name.favoriteAdd, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDataFromCellModel(notification: )), name: Notification.Name.favoriteDelete, object: nil)
    }
    
    
    ///  cell model 에 데이터 추가하는 objc 함수
    /// - Parameter notification: 전달받은 notification
    @objc func addDataToCellModel(notification: Notification){
        guard let object = notification.object as? CatFavouriteModel else {return}
        self.favoriteCellModel.append(object)
    }
    
    ///  cell model 에 데이터 삭제하는 objc 함수
    /// - Parameter notification: 전달받은 notification
    @objc func deleteDataFromCellModel(notification: Notification){
        print("deleteDataFromCellModel")
        guard let object = notification.object as? CatFavouriteModel else {
            print("deleteDataFromCellModel object not found"); return}
        guard let favourite_id = object.favourite_id else {print("deleteDataFromCellModel favourite_id not found");return}
        guard let index = self.favoriteCellModel.firstIndex(where: {$0.favourite_id == favourite_id}) else {
            print("deleteDataFromCellModel index not found"); return }
        
        self.favoriteCellModel.remove(at: index)
      
        self.catService.deleteFavouriting(favourite_id: favourite_id)
        
        
    }
}
