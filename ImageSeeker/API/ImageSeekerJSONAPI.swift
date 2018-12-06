//
//  ImageSeekerJSONAPI.swift
//  ImageSeeker
//
//  Created by ntunin on 30/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class ImageSeekerJSONAPI: ImageSeekerAPI {
    
    let response: SearchImagesResponse?
    
    init(_ jsonName: String) throws {
        if let url = Bundle.main.url(forResource: jsonName, withExtension: "json") {
            let data = try Data(contentsOf: url)
            let string = String(data: data, encoding: .utf8)!
            response = Mapper<SearchImagesResponse>().map(string)
        } else {
            response = nil
        }
    }
    
    func getImages(_ query: String, page: Int, count: Int, callback: @escaping ([SearchImageItem]?, Int) -> Void) {
        guard let response = response else {
            return
        }
        let start = (page - 1)*count
        let end = min(start + count, response.items?.count ?? 0)
        let result = Array(response.items?[start ..< end] ?? [])
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            callback(result, response.totalCount)
        }
    }
    
    
}
