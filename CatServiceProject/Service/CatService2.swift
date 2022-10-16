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
    
    func postFavouriting(completion: @escaping (Bool,EntityOfFavouriteResponse?,String?) -> ())
    func getImageID(_ image_ID: String)
    
    func getFavouriting(completion: @escaping (Bool,[EntityOfFavouriteData]?,String?) -> ())
    func deleteFavouriting(favourite_id: Int)
    
    func upLoadImage(_ image: UIImage, completion: @escaping (Bool,CatLodedResponseModel?,String?) -> Void)
}

protocol RxCatServiceProtocol{
    
    func rxGetCatData() -> Observable<[EntityOfCatData]>
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
    private var userID = "user-123"
    
    

    
    func upLoadImage(_ image: UIImage, completion: @escaping ((Bool,CatLodedResponseModel?,String?)-> Void)){
       
        let imageFile = UpLoadImageFile(fileName: "cat", mimeType: "image/jpeg", fileData: image.jpegData(compressionQuality: 1))
        
        repository.POST(url: upLoadKeyResource, params: [:], body: [imageFile], httpHeader: .multipart_form_data) { success, data in
            switch success {
            case true:
                do {
                    let model = try JSONDecoder().decode(CatLodedResponseModel.self, from: data!)
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
    func deleteFavouriting(favourite_id: Int) {
        let deleteURL = favouriteAPIResource + "/\(favourite_id)"
        Repository().DELETE(url: deleteURL, params: [:], httpHeader: .application_json) { success, data in
            if success{
                print("deleteFavouriting Success")
            }else {
                
            }
        }
    }
    
    
    /// ViewModel Data -> Service Data (좋아하는 이미지 추가기능 post method Body)
    /// - Parameter image_ID: 이미지의 id
    func getImageID(_ image_ID: String) {
        self.favoriteBody = ["image_id" : image_ID , userKey : userID]
    }
    
    func getFavouriting(completion: @escaping (Bool,[EntityOfFavouriteData]?,String?) -> ()){
        self.favoriteparams = ["sub_id" : "user-123"]
        repository.GET(url: favouriteAPIResource, params: favoriteparams, httpHeader: .application_json) { result in
            
            switch result{
            case let .success(data):
                do {
                    let model = try JSONDecoder().decode([EntityOfFavouriteData].self, from: data)
                    completion(true, model, nil)
                    
                }catch{
                    completion(false, nil, "Error: Trying to pase EntityOfFavouriteData to model")
                    
                }
            case let .failure(err):
                completion(false,nil,"Error: EntityOfFavoriteData Post Request failed")
                
            }
        }
        
    }
    
    /// 서버에 좋아하는 이미지 값(image_id) 전달하는 함수 service -> repository
    /// - Parameter completion: 이미지 값(image_id) 을 전달하고 Response 받아서 콜백함수 호출
    func postFavouriting(completion: @escaping (Bool,EntityOfFavouriteResponse?,String?) -> ()) {
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: favoriteBody) else {  return }
        
        repository.POST(url: favouriteAPIResource, params: [:] ,body: [jsonData], httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(EntityOfFavouriteResponse.self, from: data!)
                    completion(true, model, nil)
                }catch{
                    completion(false, nil, "Error: Trying to pase EntityOfFavoriteData to model")
                }
            }else{
                completion(false,nil,"Error: EntityOfFavoriteData Post Request failed")
            }
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
                    completion(false, nil, NSError(domain: "Error: Trying to pase [EntityOFCatData] to model",
                                                   code: CatServiceErrorCode.jsonDecodeError.rawValue))
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


