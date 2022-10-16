//
//  CatMainViewModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/12.
//

import Foundation
import RxSwift
import RxCocoa

protocol FavoriteFlagDataSendDelegate {
    func favoriteToggle(_ favorite: Bool, _ indexPath: IndexPath, _ image_URL : String,_ image_id: String)
}


protocol RxViewModelType{
    
    // input
    var onDataObserver: AnyObserver<Void> { get }
    
    
    // output
    var allCatData: Observable<[CatCellModel]> { get }
}

class CatMainViewModel: NSObject, RxViewModelType {
    private var catService: CatServiceType
    
    
    /// CollectionView reload Closure
    var reloadCollectionView: (() -> Void)?
    
    var cats = [EntityOfCatData]()
    
    
    var onDataObserver: AnyObserver<Void>
    
    var allCatData: Observable<[CatCellModel]>
    
    var disposeBag = DisposeBag()
    
    /// CatMainViewModelData
    var catsCellViewModels = [CatCellModel]() {
        didSet{
            print("catsCellViewModels didset Call`")
            reloadCollectionView?()
        }
    }
    
    /// CatMainViewModel init
    /// - Parameter catService: CatService인스턴스를 default값으로 전달 (CatServiece 인스턴스는 전체 데이터를 가져오기위한 클래스)
    init(catService: CatServiceType = CatService2() ) {
        self.catService = catService
        let dataPipe = PublishSubject<Void>()
        let cellDataPipe = BehaviorSubject<[CatCellModel]>(value: [])
        
        self.onDataObserver = dataPipe.asObserver()
        
        allCatData = cellDataPipe
        
        super.init()
        
        dataPipe
            .flatMap( catService.rxGetCatData )
            .map( fetchDataToCellModel(cats:) )
            .subscribe(onNext: cellDataPipe.onNext(_:))
            .disposed(by: disposeBag)
       
        self.addNotificationObserver()
        
    }
 
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(forName: Notification.Name.deleteActInFC, object: nil, queue: nil, using: { notification in
            
            guard let favourite_dic = notification.userInfo as? [String : Int] else {return}
           if let index =
            self.catsCellViewModels
            .firstIndex(where: {$0.favorite_id == favourite_dic["favourite_id"]}){
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
    
    
    /// CatMainViewModel favorite ? Add : Delete
    /// - Parameters:
    ///   - favorite: cell favorite Button add or Delete
    ///   - id: cell  image id
    ///   - indexPath: cell 위치
    func postFavoriteToggleData(_ favorite: Bool,_ image_id: String,_ image_URL:String, _ indexPath: IndexPath){
        self.catsCellViewModels[indexPath.row].favoriteFlag = favorite
        
        if favorite{
            catService.getImageID(image_id)
            catService.postFavouriting{ [weak self] success,model ,error in
                guard let self = self else {return}
                guard let model = model else {return}
                guard let favourite_id = model.id else {return}
            
                if success {
                    self.catsCellViewModels[indexPath.row].favorite_id = favourite_id
                    self.notifyAddFavouriteViewModel(favourite_id, image_id, image_URL)
                    print("favourite add success")
                }else {
                    print("favourite add fail!")
                }
            }
        }else{
             let favourite_id = self.catsCellViewModels[indexPath.row].favorite_id 
        
            self.notifyDeleteFavouriteViewModel(favourite_id, image_id, image_URL)
        }
    }
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
            cellmodel.append(CatCellModel(imageURL: imageURL, id: id, favorite_id: 0))
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
            
            cellmodel.append(CatCellModel(imageURL: imageURL, id: id, favorite_id: 0))
        }
       self.catsCellViewModels = cellmodel
        
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
