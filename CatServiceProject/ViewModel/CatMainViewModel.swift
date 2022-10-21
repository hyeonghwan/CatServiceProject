//
//  CatMainViewModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/12.
//

import Foundation
import RxSwift
import RxCocoa

//protocol FavoriteFlagDataSendDelegate {
//    func favoriteToggle(_ favorite: Bool, _ indexPath: IndexPath, _ image_URL : String,_ image_id: String)
//}


protocol RxViewModelType {
    
    // input
    var onDataObserver: AnyObserver<Void> { get }

    // output
    var allCatData: Observable<[CatCellModel]> { get }
    
    var favouriteHeartObserver: AnyObserver<UpdatedHeartModel> { get }
}


class CatMainViewModel: NSObject, RxViewModelType {
    
    private var catService: CatServiceType

    let container: RxFaovurtieType
    
    /// CollectionView reload Closure
    var reloadCollectionView: (() -> Void)?
    
    var cats = [EntityOfCatData]()
    
    
    var onDataObserver: AnyObserver<Void>
    
    var favouriteHeartObserver: AnyObserver<UpdatedHeartModel>
    
//    var favouriteSuccessObservable: Observable<CatFavouriteModel>
//
//    var favouriteDeleteObservable: Observable<FavouriteDeleteResponseWrap>
//
    var allCatData: Observable<[CatCellModel]>
    
    var disposeBag = DisposeBag()
    
    /// CatMainViewModelData
    var catsCellViewModels = [CatCellModel]() {
        didSet{
            print("catsCellViewModels didset Call`")
            reloadCollectionView?()
        }
    }
    var dummyData = [CatCellModel(),CatCellModel(),CatCellModel(),CatCellModel(),CatCellModel(),CatCellModel(),CatCellModel()
    ]
    
    /// CatMainViewModel init
    /// - Parameter catService: CatService인스턴스를 default값으로 전달 (CatServiece 인스턴스는 전체 데이터를 가져오기위한 클래스)
    init(catService: CatServiceType = CatService2(),
         conatiner: RxEventType) {
        
        self.catService = catService
        
        self.container = conatiner
        
        let dataPipe = PublishSubject<Void>()
        let cellDataPipe = BehaviorSubject<[CatCellModel]>(value: dummyData)

        
        let heartPipe = PublishSubject<UpdatedHeartModel>().share()
    
        self.favouriteHeartObserver = heartPipe.asObserver()
        
        self.onDataObserver = dataPipe.asObserver()
        

        
        allCatData = cellDataPipe
        
        super.init()
    
            
        
        dataPipe
            .flatMap( catService.rxGetCatData )
            .map( fetchDataToCellModel(cats:) )
            .subscribe(onNext: cellDataPipe.onNext(_:))
            .disposed(by: disposeBag)
        
        heartPipe
            .filter{ $0.changedFavourite == true}
            .map(UpdatedHeartModel.transFormToFavouitePostModel(_:))
            .flatMap{ postModel in
                catService.rxPostResponse(postModel)}
            .withLatestFrom(cellDataPipe){ responseData, originals in
                
                originals.map{ cellModel in
                    
                    guard cellModel.catID == responseData.imageID else {return cellModel}
                    
                    let convertedData = cellModel.addFavourite(responseData)
                    
                    conatiner.observer1.onNext(responseData.addImageURL(cellModel.imageURL))
                    
                    return convertedData
                }
            }
            .subscribe(onNext: { cellDataPipe.onNext($0)})
            .disposed(by: disposeBag)

        heartPipe
            .filter{ $0.changedFavourite == false}
            .map(UpdatedHeartModel.getToDeleteFavouriteID(_:))
            .flatMap(catService.rxDeleteFavouriteData(_:))
            .withLatestFrom(cellDataPipe){ responseData, originals in
        
                originals.map{ cellModel in
                    
                    guard cellModel.catID == responseData.imageID else {return cellModel}
                    
                    let convertedData = cellModel.deleteFavourite(responseData)
                    
                    conatiner.heartObserver.onNext(responseData)
                    
                    return convertedData
                }
            }
            .subscribe(onNext: { cellDataPipe.onNext($0) })
            .disposed(by: disposeBag)
        
    
        
        let deleteFromFavouriteViewModel = PublishSubject<FavouriteDeleteResponseWrap>()
        
        conatiner
            .favouriteDeleteObservable
            .subscribe(onNext: deleteFromFavouriteViewModel.onNext(_:))
            .disposed(by: disposeBag)
        
        deleteFromFavouriteViewModel
            .withLatestFrom(cellDataPipe){ deleteData , originals in
                originals.map{ model in
                    guard model.catID == deleteData.imageID else {return model}
                    return CatCellModel(catCellModel: model, deleteData)
                }
            }.subscribe(onNext: cellDataPipe.onNext(_:))
            .disposed(by: disposeBag)
        
    }
    
    func postMethod(_ cellDataPipe: BehaviorSubject<[CatCellModel]>) {
       
    }
    
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(forName: Notification.Name.deleteActInFC, object: nil, queue: nil, using: { notification in
            
            guard let favourite_dic = notification.userInfo as? [String : Int] else {return}
            if let index =
                self.catsCellViewModels
                .firstIndex(where: {$0.favouriteID == favourite_dic["favourite_id"]}){
                self.catsCellViewModels[index].favoriteFlag = false
            }
            
            
        })
    }
    
    
    /// CatService 의 getCatDataUsingCatServiceProtocol( 전체 데이터 가져오는 함수)  호출 -> [EntityOfCatData]
    func getCats() {
        catService.getCatDataUsingCatServiceProtocol{ success, model , error in
            if success, let cats = model {
                self.fetchData(cats: cats)
            }else {
                print(error!)
            }
        }
    }//getCats
    
}

private extension CatMainViewModel{
    
    /// Repository 에서 viewmodel 데이터로 변형 [EntityOfCatData] -> [CatCellViewModel]
    /// - Parameter cats: [EntityOfCatData]
    func fetchDataToCellModel(cats: [EntityOfCatData]) -> [CatCellModel]{
        
        self.cats = cats //cache
        var cellmodel = [CatCellModel]()
        
        for cat in cats {
            guard let id = cat.id else {print("cat id error"); return [] }
            guard let imageURL = cat.imageURL else {print("cat url error"); return [] }
            cellmodel.append(CatCellModel(imageURL: imageURL, catID: id, favouriteID: nil))
        }
        
       return cellmodel
    }
    
    /// Repository 에서 viewmodel 데이터로 변형 [EntityOfCatData] -> [CatCellViewModel]
    /// - Parameter cats: [EntityOfCatData]
    func fetchData(cats: [EntityOfCatData]){
        
        self.cats = cats //cache
        var cellmodel = [CatCellModel]()
        
        for cat in cats {
            guard let id = cat.id else {print("cat id error"); return}
            guard let imageURL = cat.imageURL else {print("cat url error"); return}
            
            cellmodel.append(CatCellModel(imageURL: imageURL, catID: id, favouriteID: nil))
        }
       self.catsCellViewModels = cellmodel
        
    }
    
    
    func responseToFavouriteModel(_ entityModel: EntityOfFavouriteResponse) -> EntityOfFavouriteResponse {
        let entity: EntityOfFavouriteResponse = entityModel
    
        return entity
    }
    
    
    /// notify AddAction to FavouriteViewModel
    /// - Parameters:
    ///   - favourite_id: 즐겨찾기 id ( Int )
    ///   - image_id: image_id
    ///   - image_URL: image_URL
    func notifyAddFavouriteViewModel(_ favourite_id: Int,_ image_id: String,_ image_URL: String) {
            let data = CatFavouriteModel(favourite_id: favourite_id, imageID: image_id, imageURL: image_URL)
            
            NotificationCenter.default.post(name: Notification.Name.favoriteAdd,
                                            object:  data,
                                            userInfo: nil)
    }
    
    /// notify DeleteAction to FavouriteViewModel
    /// - Parameters:
    ///   - favourite_id: 즐겨찾기 id ( Int )
    ///   - image_id: image_id
    ///   - image_URL: image_URL
    func notifyDeleteFavouriteViewModel(_ favourite_id: Int,_ image_id: String,_ image_URL: String) {
            let data = CatFavouriteModel(favourite_id: favourite_id, imageID: image_id, imageURL: image_URL)
            
        NotificationCenter.default.post(name: Notification.Name.favoriteDelete,
                                            object:  data,
                                            userInfo: nil)
    }
}


//        heartPipe
//            .map{UpdatedHeartModel.updateHeart($0)}
//            .withLatestFrom(cellDataPipe){ (updatedModel, originals) -> [CatCellModel] in
//                originals.map{ data in
//                    guard data.catID == updatedModel.catID else { return data}
//                    return updatedModel
//                }
//            }
//            .subscribe(onNext: cellDataPipe.onNext)
//            .disposed(by: disposeBag)
