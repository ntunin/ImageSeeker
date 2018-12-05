//
//  Entity.swift
//  ImageSeeker
//
//  Created by ntunin on 04/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class Entity: NSObject {
    
    
    @objc var objectId: String?
    
    required override init() {
        self.objectId = UUID().uuidString
    }
    
    required init(_ objectId: String?) {
        self.objectId = objectId
    }
}
