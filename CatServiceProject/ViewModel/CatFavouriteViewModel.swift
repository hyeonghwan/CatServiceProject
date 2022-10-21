//
//  CatFavouriteViewModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/13.
//

import Foundation
import RxSwift
import RxCocoa


protocol RxDeleteModelType {
    
    var onDeleteObserver: AnyObserver<DeleteFavouriteModel> {get}
    
    var deleteObservable: Observable<DeleteFavouriteModel> { get }
}


protocol RxFavouriteViewModelType: RxDeleteModelType{
    
    var onFavouriteData: AnyObserver<GETMOMEL> { get }
    
    var allFavourites: Observable<[CatFavouriteModel]> { get }
    
}

class CatFavouriteViewModel: RxFavouriteViewModelType {
    
    private var catService: CatServiceType
    
//    var viewType: VMType = .favourite
    
    var favoriteCollectionViewReload: (() -> Void)?
    
    var favoriteCellModel = [CatFavouriteModel]() {
        didSet{
            favoriteCollectionViewReload?()
        }
    }
    
    var container: RxDeleteType
    
    
    
    var onFavouriteData: AnyObserver<GETMOMEL>
    
    var allFavourites: Observable<[CatFavouriteModel]>
    
    var onDeleteObserver: AnyObserver<DeleteFavouriteModel>
    var deleteObservable: Observable<DeleteFavouriteModel>
   
    var disposeBag = DisposeBag()
    
    
    var dummyData = [CatFavouriteModel(),CatFavouriteModel(),CatFavouriteModel(),CatFavouriteModel(),CatFavouriteModel(),CatFavouriteModel()]
    
    init(_ catService: CatServiceType ,
         container: RxEventType) {
        
        self.catService = catService
        
        self.container = container
        
        let eventPipe = PublishSubject<GETMOMEL>()
        
        let deletePipe = PublishSubject<DeleteFavouriteModel>()
        
        let dataPipe = BehaviorSubject<[CatFavouriteModel]>(value: dummyData)
    
        
        onDeleteObserver = deletePipe.asObserver()
        
        onFavouriteData = eventPipe.asObserver()
        
        allFavourites = dataPipe

        
        let notifyDelete = PublishSubject<DeleteFavouriteModel>()
        deleteObservable = notifyDelete
            
        eventPipe
            .flatMap(catService.rxGetFavouriteData)
            .map(fetchToFavouriteData)
            .subscribe(onNext: dataPipe.onNext(_:))
            .disposed(by: disposeBag)
        
   
        deletePipe
            .map{data in
                 return data }
            .flatMap(catService.rxDeleteFavouriteData(_:))
            .withLatestFrom(dataPipe){ responseData, originals in
                
                container.observer2.onNext(responseData)
                
                return originals.map{ cellModel in
                    
                    guard cellModel.imageID == responseData.imageID else {return cellModel}
                    
                    return CatFavouriteModel()
                }
            }.map{ $0.filter{ data in data.favourite_id != nil}}
            .subscribe(onNext: dataPipe.onNext(_:))
            .disposed(by: disposeBag)
        
        
        
        container
            .favouriteSuccessObservable
            .subscribe(onNext: {
                do{
                    try dataPipe.onNext( dataPipe.value() + [CatFavouriteModel($0)])
                } catch {
                    print(error)
                }
            }).disposed(by: disposeBag)
        
        container
            .heartActionDeleteObservable
            .map{ data in DeleteFavouriteModel(data)}
            .subscribe(onNext: deletePipe.onNext(_:))
            .disposed(by: disposeBag)
        
    }
    
}

private extension CatFavouriteViewModel{

    
    /// FetchData - 서버에서 가져온 데이터를 Cell에 보여줄 데이터로 변형
    /// - Parameter favorEntities: 서버에서 가져온 Data
    func fetchData(_ favorEntities: [EntityOfFavouriteData]){
        for favor in favorEntities {
            guard let id = favor.favouriteID else {print("CatFavouriteViewModel id error"); return}
            guard let imageID = favor.imageID_URL.id else {print("CatFavouriteViewModel imageID error"); return}
            guard let imagURL = favor.imageID_URL.url else {print("CatFavouriteViewModel imageURL error"); return}
            favoriteCellModel.append(CatFavouriteModel(favourite_id: id,imageID: imageID, imageURL: imagURL))
        }
    }
    
    /// FetchData - 서버에서 가져온 데이터를 Cell에 보여줄 데이터로 변형
    /// - Parameter favorEntities: 서버에서 가져온 Data
    func fetchToFavouriteData(_ favouriteEntities: [EntityOfFavouriteData]) -> [CatFavouriteModel] {
        return favouriteEntities.map{entity in
            
            if let favouriteID = entity.favouriteID,
               let imageID = entity.imageID_URL.id,
               let imageURL = entity.imageID_URL.url{
                
                return CatFavouriteModel(favourite_id: favouriteID,
                                  imageID: imageID,
                                  imageURL: imageURL)
            }
            
            return CatFavouriteModel()
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
      
//        self.catService.deleteFavouriting(favourite_id: favourite_id)
        
        
    }
}
