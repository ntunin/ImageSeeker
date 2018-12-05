//
//  SearchItem.swift
//  ImageSeeker
//
//  Created by ntunin on 29/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchImageItem: Entity {
    
    @objc var title: String?
    @objc var link: String?
    @objc var thumbnailLink: String?
    
    init(title: String, link: String, thumbnailLink: String) {
        super.init(nil)
        self.title = title
        self.link = link
        self.thumbnailLink = thumbnailLink
    }
    
    required init(_ objectId: String?) {
        super.init(objectId)
    }
    
    required init() {
        super.init()
    }
    
}
