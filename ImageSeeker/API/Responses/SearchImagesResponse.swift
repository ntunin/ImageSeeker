//
//  SearchImagesResponse.swift
//  ImageSeeker
//
//  Created by ntunin on 29/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchImagesResponse: Mappable {
    
    var items: [SearchImageItem]?
    var totalCount = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        var countString = ""
        countString <- map["queries.request.0.totalResults"]
        totalCount = Int(countString) ?? 0
        items <- map["items"]
    }
    

}
