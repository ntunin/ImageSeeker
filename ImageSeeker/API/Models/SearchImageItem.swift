//
//  SearchItem.swift
//  ImageSeeker
//
//  Created by ntunin on 29/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchImageItem: Mappable {
    
    var title: String?
    var link: String?
    var thumbnailLink: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        link <- map["link"]
        thumbnailLink <- map["image.thumbnailLink"]
    }
    
}
