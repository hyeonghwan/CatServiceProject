//
//  UpLoadImageFile.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/16.
//

import Foundation


struct UpLoadImageFile: Codable {
    let fieldName: String = "file"
    let fileName: String?
    let mimeType: String?
    let fileData: Data?

}
//fieldName: String, fileName: String, mimeType: String, fileData: Data
