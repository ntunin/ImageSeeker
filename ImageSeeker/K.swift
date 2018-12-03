//
//  K.swift
//  ImageSeeker
//
//  Created by ntunin on 29/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

struct K {
    static let google = "Google"
    
    struct Google {
        static let API = "API"
        static let version = "version"
        static let APIKey = "API_KEY"
        static let engineId = "engineId"
    }
    
    struct SearchItemCell {
        static let reuseIdentifier = "SearchItemCell"
        static let nib = UINib(nibName: "SearchItemCell", bundle: nil)
    }
    
    struct Notifications {
        static let onRightNavigationButtonClick = NSNotification.Name(rawValue: "onRightNavigationButtonClick")
    }
}
