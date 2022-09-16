//
//  RepositoryExtension.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/16.
//

import Foundation

extension Repository{
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    }
    
    func convertFileData(upLoadImage: UpLoadImageFile, using boundary: String) -> Data {
      let data = NSMutableData()

        guard let fileName = upLoadImage.fileName else {print("convertFileData fileData error"); return Data()}
        guard let mimeType = upLoadImage.mimeType else {print("convertFileData fileData error"); return Data()}
        guard let fileData = upLoadImage.fileData else {print("convertFileData fileData error"); return Data()}
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(upLoadImage.fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data as Data
    }
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
