//
//  NetworkHandler.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/03.
//

import Foundation
import UIKit
class NetworkHandler {
     
    class func getData(resource: String, complitionBlock: @escaping ([EntityOfCatData]) -> ()) {
        // 세션 생성, 환경설정
        let defaultSession = URLSession(configuration: .default)

        guard let url = URL(string: "\(resource)") else {
            print("URL is nil")
            return
        }
    
        let header : [String : String] = [
            "x-api-key" : "live_kr1uWfeTG36BkaS1wKowAR2yiX80b4Ay9dHD4kCS4EdcywLg2OFj6mOcFytY6fSG",
            "Content-Type" : "application/json"]
        
        // Request
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }

            // 통신에 성공한 경우 data에 Data 객체가 전달됩니다.

            // 받아오는 데이터가 json 형태일 경우,
            // json을 serialize하여 json 데이터를 swift 데이터 타입으로 변환
            // json serialize란 json 데이터를 String 형태로 변환하여 Swift에서 사용할 수 있도록 하는 것을 말합니다.
            guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else {
                print("json to Any Error")
                
                return
            }
            print(jsonToArray)
//            print(jsonToArray)
            // 원하는 작업
            let decoder = JSONDecoder()
            if let catDataArr = try? decoder.decode([EntityOfCatData].self, from: data){
                print(catDataArr)
                complitionBlock(catDataArr)
            }
        }
        dataTask.resume()
    }
}


