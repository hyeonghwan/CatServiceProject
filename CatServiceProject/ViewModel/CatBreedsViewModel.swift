//
//  CatListViewModel.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/08.
//


import UIKit
import Kingfisher
import RxSwift


typealias Breeds = [Breed]
typealias HSCollectionModels = [CatHSCollectionModel]
typealias BreedAndHSCModels = (Breeds,HSCollectionModels)

protocol RxBreedViewModelType {
    
    // input
    var onBreedsDataObserver: AnyObserver<BreedType> { get }
    
    //output
    var onHSCDataObservable: Observable<Breeds> { get }
    var pagingCountObservable: Observable<Int> { get }
}

class CatBreedsViewModel: NSObject,ImageViewModelDelegate,RxBreedViewModelType {
 
    
    // repository -> get entity
    // service -> model -> viewmodel   <- viewcontroller
    var headerImageList: [UIImage] = []
    
    private let catService: CatBreedProtocol = CatService()
    
    //input
    var onBreedsDataObserver: AnyObserver<BreedType>
    
    //output
    var pagingCountObservable: Observable<Int>
    var onHSCDataObservable: Observable<Breeds>
    
    
    private var disposeBag = DisposeBag()
    

    
    var breedCellModels: HSCollectionModels? {
        didSet {
            self.breedCellHandler?()
        }
    }
    
    var breedCellHandler: (() -> ())? {
        didSet{
            breedCellHandler?()
        }
    }
    override init(){
        
        let breedsPipe = PublishSubject<BreedType>()
        let dataPipe = BehaviorSubject<Breeds>(value: ([]))
        let paging = PublishSubject<Int>()
        
        onBreedsDataObserver = breedsPipe.asObserver()
        
        pagingCountObservable = paging
        onHSCDataObservable = dataPipe
        
        super.init()
        
        breedsPipe
            .map{requestType in
                switch requestType{
                case let .breedType(id, _, _):
                    return id
                }
            }
            .flatMap(catService.rxGetCatImageByBreed(_:))
            .do(onNext: { paging.onNext($0.count) } )   // page binding
            .map{self.fetchToBreedViewModle($0)}      // return CatHSCollectionModels
            .subscribe(onNext: { [weak self] models in
                guard let self = self else {return}
                dataPipe.onNext(models.0)
                self.breedCellModels = models.1
            })
            .disposed(by: disposeBag)
    }
    

    
    func getBVMCatImages(_ breedType: BreedType, _ completion: @escaping (BreedAndHSCModels) -> () ) {
        
        switch breedType{
        case let .breedType(id, _, _):
            
            catService.getCatImageByBreed(id){[weak self] flag, data, error in
                
                guard let self = self else {return}
                
                if flag == true,
                   let model = data,
                   error == nil{
                    
                    let fetchedData = self.fetchToBreedViewModle(model)
                    
                    //fetchedData.1 == CatHSCollectionModel
                    completion(fetchedData)
                    
                }else {
                    print(error!)
                    assert(false,"bad request")
                }
                
            }
        }
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
    
    
    /// func to fetch data to viewModelData for BreedsviewModel
    /// - Parameter entity: server에서 가져온 Data
    /// - Returns: BreedAndHSCModels (Breeds,HSCollectionModels) -> (breed정보와, ViewModelData ) tuple
    func fetchToBreedViewModle(_ entity: [EntityOfCatData]) -> BreedAndHSCModels {
        let allData = entity
        
        guard let breedInformation = allData.first else {return ([],[]) }
        
        let catHSCollectionModel = allData.map{
            guard let id = $0.id else {return CatHSCollectionModel()}
            guard let imageURL = $0.imageURL else {return CatHSCollectionModel()}
            guard let width = $0.width else {return CatHSCollectionModel()}
            guard let height = $0.height else {return CatHSCollectionModel()}
            return CatHSCollectionModel(id: id, imageURL: imageURL, width: width, height: height)
        }
        let models = self.toLoopPageDataBinding2(catHSCollectionModel)
        
        return (breedInformation.breeds,models)
    }
    
    
    /// func for PageControll loop
    /// - Parameter data: HSCollectionModels = [CatHSCollectionModel]
    /// - Returns: HSCollectionModels
    /// - Description : 앞뒤로 마지막이미지, 첫번째 이미지 append 해서  infinite paging enable
    func toLoopPageDataBinding2(_ data: HSCollectionModels) -> HSCollectionModels {
        var catHSCModel: HSCollectionModels = []
    
        catHSCModel.append(data.last!)
        
        data.forEach{
            catHSCModel.append($0)
        }
        
        catHSCModel.append(data.first!)
        
        return catHSCModel
    }
    
    
    
}
struct CatHSCollectionModel{
    let id: String
    let imageURL: String
    let width, height: Int
            
    init() {
        self.id = ""
        self.imageURL = ""
        self.width = 0
        self.height = 0
    }
    
    init(id: String, imageURL: String, width: Int, height: Int) {
        self.id = id
        self.imageURL = imageURL
        self.width = width
        self.height = height
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
