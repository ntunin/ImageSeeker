//
//  ImageSeekerGoogleAPI.swift
//  ImageSeeker
//
//  Created by ntunin on 29/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
///Users/ntunin/Documents/ImageSeeker/Podfile

import UIKit
import Alamofire
import AlamofireObjectMapper

enum GoogleApiError: Error {
    case notInitialized
}

class ImageSeekerGoogleAPI: ImageSeekerAPI {
    
    let base: String
    let version: String
    let apiKey: String
    let engineId: String
    
    init() throws {
        if let google = Bundle.main.infoDictionary![K.google] as? NSDictionary,
            let base = google[K.Google.API] as? String,
            let version = google[K.Google.version] as? String,
            let apiKey = google[K.Google.APIKey] as? String,
            let engineId = google[K.Google.engineId] as? String {
            
            self.base = base
            self.version = version
            self.apiKey = apiKey
            self.engineId = engineId
            
        } else {
            throw GoogleApiError.notInitialized
        }
    }
    
    func getImages(_ query: String, page: Int, count: Int, callback: @escaping ([SearchImageItem]?, Int)->Void) {
        Alamofire
            .request("\(base)/v1?key=\(apiKey)&cx=\(engineId)&q=\(query)&start=\((page - 1)*count + 1)&num=\(count)&searchType=image&fields=items,queries")
            .validate()
            .responseObject { (r: DataResponse<SearchImagesResponse>) in
                if let response = r.result.value {
                    callback(response.items, response.totalCount)                    
                } else {
                    callback(nil, 0)
                }
        }
    }   
    
}
