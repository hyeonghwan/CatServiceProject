//
//  CatService2.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/12.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
 
enum CatServiceErrorCode: Int {
    case jsonDecodeError = 1
}

protocol CatServiceProtocol {
    
     func getCatDataUsingCatServiceProtocol(completion: @escaping (Bool, [EntityOfCatData]?, Error?) -> ()  )
    
    func postFavouriting(postModel: POSTMODEL,completion: @escaping (Bool,EntityOfFavouriteResponse?,Error?) -> ())
    
    func getFavouriting(params: GETMOMEL, completion: @escaping (Bool,[EntityOfFavouriteData]?,Error?) -> ())
    
    func deleteFavouriting(deleteModel: DELETEMODEL, completion: @escaping (EntityOfDeleteResponse?,Error?) -> ())
    
    func upLoadImage(_ image: UIImage, completion: @escaping (Bool,CatLodedResponseModel?,String?) -> Void)
}

protocol RxCatServiceProtocol{
    
    func rxGetCatData() -> Observable<[EntityOfCatData]>
    
    func rxPostResponse(_ postModel: POSTMODEL) -> Observable<FavouriteResponseWrap>
    
    func rxGetFavouriteData(_ userID: GETMOMEL) -> Observable<[EntityOfFavouriteData]>
    
    func rxDeleteFavouriteData(_ deleteModel: DELETEMODEL) -> Observable<FavouriteDeleteResponseWrap>
}

typealias CatServiceType = RxCatServiceProtocol & CatServiceProtocol

class CatService2: CatServiceType {
  
    private let repository = Repository()

    
    /* Image GET key 값*/
    private let getImageURLResource = "https://api.thecatapi.com/v1/images/search"
    private let params: [String : String] = ["format":"json","limit":"12"]
    
    
    /* Favorite POST / GET key 값*/
    private let favouriteAPIResource = "https://api.thecatapi.com/v1/favourites"
    private var favoriteparams: [String : String] = [:]
    private var favoriteBody: [String : String] = [:]
    
    /* upLoad key 값*/
    private let upLoadKeyResource = "https://api.thecatapi.com/v1/images/upload"
    
    private var userKey = "sub_id"
    private var userID = " "
    
    

    
    func upLoadImage(_ image: UIImage, completion: @escaping ((Bool,CatLodedResponseModel?,String?)-> Void)){
       
        let imageFile = UpLoadImageFile(fileName: "cat", mimeType: "image/jpeg", fileData: image.jpegData(compressionQuality: 1))
        
        repository.POST(url: upLoadKeyResource, params: [:], body: [], httpHeader: .multipart_form_data) { result in
            switch result {
            case let .success(data):
                do {
                    let model = try JSONDecoder().decode(CatLodedResponseModel.self, from: data)
                    completion(true,model,nil)
                }catch{
                    print("upload decode Error occur")
                    completion(false,nil,nil)
                }
            default:
                completion(false,nil,nil)
                break
            }
        }
    }
    
    
    /// DELETE Method call -> delete data using favourite_id from FavouriteList
    /// - Parameter favourite_id: delete data ID
    func deleteFavouriting(deleteModel: DELETEMODEL, completion: @escaping (EntityOfDeleteResponse?,Error?) -> ()) {
        let deleteURL = favouriteAPIResource + "/\(deleteModel.favouriteID)"
        Repository().DELETE(url: deleteURL, params: [:], httpHeader: .application_json) { result  in
            
            switch result {
            case let .success(data):
                do {
                    let model = try JSONDecoder().decode(String.self, from: data)
                    completion( EntityOfDeleteResponse(message: model), nil )
                }catch{
                    completion(nil, NSError.serviceError(ServiceErrorCode.jsonDecodingError))
                }
            case let .failure(error):
                completion(nil,error)
            }
        }
    }
    
    func rxDeleteFavouriteData(_ deleteModel: DELETEMODEL) -> Observable<FavouriteDeleteResponseWrap>{
        return Observable.create{ [weak self] emiter in
            
            self?.deleteFavouriting(deleteModel: deleteModel){ message,error  in
                if error == nil,
                   message?.message != nil{
                    emiter.onNext(FavouriteDeleteResponseWrap(imageID: deleteModel.imageID, message: message?.message ?? ""))
                }else {
                    print(error!)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    
    /// ViewModel Data -> Service Data (좋아하는 이미지 추가기능 post method Body)
    /// - Parameter image_ID: 이미지의 id
    func getImageID(_ image_ID: String) {
        self.favoriteBody = ["image_id" : image_ID , userKey : userID]
    }
    
    func getFavouriting(params: GETMOMEL,completion: @escaping (Bool,[EntityOfFavouriteData]?,Error?) -> ()){
        
        repository.GET(url: favouriteAPIResource, params: params.subID, httpHeader: .application_json) { result in
            switch result{
            case let .success(data):
                do {
                    let model = try JSONDecoder().decode([EntityOfFavouriteData].self, from: data)
                    completion(true, model, nil)
                }catch{
                    completion(false, nil, NSError.serviceError(ServiceErrorCode.jsonDecodingError))
                }
            case let .failure(error):
                completion(false,nil,error)
            }
        }
    }
    
    func rxGetFavouriteData(_ userID: GETMOMEL) -> Observable<[EntityOfFavouriteData]>{
        return Observable<[EntityOfFavouriteData]>.create{ [weak self] emiter in
            
            self?.getFavouriting(params: userID, completion: { resultFlag, data, error in
                if resultFlag,
                   error == nil,
                   let data = data {

                    print(data)
                    emiter.onNext(data)
                    
                }else {
                    print(error!)
                }
            })
            return Disposables.create()
        }
    }
    
    /// 서버에 좋아하는 이미지 값(image_id) 전달하는 함수 service -> repository
    /// - Parameter completion: 이미지 값(image_id) 을 전달하고 Response 받아서 콜백함수 호출
    func postFavouriting(postModel: POSTMODEL,completion: @escaping (Bool,EntityOfFavouriteResponse?,Error?) -> ()) {

        guard let jsonData = try? JSONSerialization.data(withJSONObject: postModel.body) else {  return }
        print(postModel.body)
        repository.POST(url: favouriteAPIResource, params: [:] ,body: [jsonData], httpHeader: .application_json) { result in
            
            switch result {
            case let .failure(error):
                completion(false,nil,error)
                
            case let .success(data):
                do {
                    let model = try JSONDecoder().decode(EntityOfFavouriteResponse.self, from: data)
                    completion(true, model, nil)
                }catch{
                    completion(false, nil, NSError.serviceError(ServiceErrorCode.jsonDecodingError))
                }
            }
        }
    }
    
    
    func rxPostResponse(_ postModel: POSTMODEL) -> Observable<FavouriteResponseWrap>{
        return Observable<FavouriteResponseWrap>.create{ observer in
            self.postFavouriting(postModel: postModel, completion: { resultFlag,responseModel,error in
                if resultFlag,
                   error == nil,
                   let responseModel = responseModel {
                    observer.onNext(FavouriteResponseWrap(responseModel, postModel.imageID))
                }else {
                    print(error!)
                }
            })
            return Disposables.create()
        }
    }
    
    /// 첫 메인 뷰컨트롤러 이미지 에 대한 전체 데이터 불러오는 함수
    /// - Parameter completion: 데이터를 불러온뒤 실행되는 콜백함수
    func getCatDataUsingCatServiceProtocol(completion: @escaping (Bool, [EntityOfCatData]?, Error?) -> ()) {
        repository.GET(url: getImageURLResource, params: params , httpHeader: .application_json) {
            result in
            switch result{
            case let .failure(error):
                completion(false,nil,error)
                
            case let .success(data):
                do {
                    let model = try JSONDecoder().decode([EntityOfCatData].self, from: data)
                   
                    completion(true, model, nil)
                    
                }catch{
                    
                    completion(false, nil, NSError.serviceError(ServiceErrorCode.jsonDecodingError))
                }
            }
        }
    } //getCatDataUsingCatServiceProtocol

    
    func rxGetCatData() -> Observable<[EntityOfCatData]> {
        
        return Observable.create{ observer in
            self.getCatDataUsingCatServiceProtocol{ flag, data , error in
                if flag == true, error == nil {
                    observer.onNext(data!)
                    observer.onCompleted()
                }else {
                    observer.onError(error!)
                }
            }
            return Disposables.create()
        }
    }
    
}


