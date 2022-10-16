//
//  Repository.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/06.
//

import Foundation

enum HTTPHeaderFields {
    case application_json
    case multipart_form_data
    case none
}


final class Repository {
    
    private let apiValue = "live_kr1uWfeTG36BkaS1wKowAR2yiX80b4Ay9dHD4kCS4EdcywLg2OFj6mOcFytY6fSG"
    private let apiKey = "x-api-key"
    
    func DELETE(url: String, params: [String : String], httpHeader: HTTPHeaderFields, complete: @escaping (Bool,Data?) -> () ) {
        guard var components = URLComponents(string: url) else {
            print("Post Error: cannot create URLComponets")
            return
        }
        if !params.isEmpty{
            components.queryItems = params.map{ key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        guard let url = components.url else {
            print("Error: cannot crate URL")
            return
        }
          
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        switch httpHeader {
        case .application_json:
            request.setValue(apiValue, forHTTPHeaderField: apiKey)
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        case .none:
            break
        case .multipart_form_data:
            break
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request){ data,response,error in
            guard error == nil else {
                print("Error: problem calling Post")
                print(error!)
                complete(false, nil)
                return
            }
            guard let data = data else {
                print("Did not receive data")
                complete(false, nil)
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                
                print("Error: HTTP request failed")
                complete(false, nil)
                return
            }
            complete(true, data)
        }.resume()
    }
    
    func POST(url: String, params: [String : String],body: [Any], httpHeader: HTTPHeaderFields, complete: @escaping (Bool,Data?) -> () ) {
        
        guard var components = URLComponents(string: url) else {
            print("Post Error: cannot create URLComponets")
            return
        }
        
        if !params.isEmpty{
            components.queryItems = params.map{ key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        guard let url = components.url else {
            print("Error: cannot crate URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        switch httpHeader {
            
        case .application_json:
            
            request.setValue(apiValue, forHTTPHeaderField: apiKey)
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            let httpBody = NSMutableData()
            for data in body{
                guard let data = data as? Data
                else {print("POst Body Optional binding Error"); return}
                
                httpBody.append(data)
            }
            
        case .multipart_form_data:
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue(apiValue, forHTTPHeaderField: apiKey)
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let httpBody = NSMutableData()

            for data in body{
                guard let upLoadImageFile = data as? UpLoadImageFile else {return}
                
                httpBody.append(convertFileData(upLoadImage: upLoadImageFile,
                                                using: boundary))
            }

            httpBody.appendString("--\(boundary)--")
            let data = httpBody as Data
            print(type(of: data))
            request.httpBody = httpBody as Data

            break
        case .none:
            break
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request){ data,response,error in
            
            guard error == nil else {
                print("Error: problem calling Post")
                print(error!)
                complete(false, nil)
                return
            }
            
            guard let data = data else {
                print("Did not receive data")
                complete(false, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            print("response status: \(response.statusCode)")
            if  (200..<300) ~= response.statusCode {
                complete(true, data)
            }else {
                print("Error: HTTP request failed")
                print(response)
                complete(false, nil)
            }
           
            
        }.resume()
    }
    
    
    func GET(url: String, params: [String: String], httpHeader: HTTPHeaderFields, complete: @escaping (Bool,Data?) -> () ){
        guard var components = URLComponents(string: url) else {
            print("Error: cannot create URLComponents")
            return
        }
        print("GETEDD")
        print("GET: \(params)")
        components.queryItems = params.map{ key, value in
            URLQueryItem(name: key, value: value)
        }
        guard let url = components.url else {
            print("Error: cannot crate URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        switch httpHeader {
        case .application_json:
            request.setValue(apiValue, forHTTPHeaderField: apiKey)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .multipart_form_data:
            break
        case .none:
            break
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request){ data,response,error in
            guard error == nil else {
                print("Error: problem calling GET")
                print(error!)
                complete(false, nil)
                return
            }
            guard let data = data else {
                print("Did not receive data")
                complete(false, nil)
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                complete(false, nil)
                return
            }
            complete(true, data)
        }.resume()
    }
    
    
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

           let decoder = JSONDecoder()
           if let catDataArr = try? decoder.decode([EntityOfCatData].self, from: data){
               complitionBlock(catDataArr)
           }
       }
       dataTask.resume()
   }
}



// 통신에 성공한 경우 data에 Data 객체가 전달됩니다.

// 받아오는 데이터가 json 형태일 경우,
// json을 serialize하여 json 데이터를 swift 데이터 타입으로 변환
// json serialize란 json 데이터를 String 형태로 변환하여 Swift에서 사용할 수 있도록 하는 것을 말합니다.
//           guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else {
//               print("json to Any Error")
//               return
//           }
//            print(jsonToArray)
// 원하는 작업
