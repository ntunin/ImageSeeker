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
        static let onLeftNavigationButtonClick = NSNotification.Name(rawValue: "onLeftNavigationButtonClick")
    }
    
    struct Storage {
        static let ModelName = "ImageSeeker"
        struct Tables {
            static let SearchImageItems = "SearchImageItems"
        }
    }
    
    struct Animation {
        static let defaultDuration = 0.3
    }
    
    struct Binding {
        
        struct Property {
            static let keyPath = "_value"            
        }
        
        struct Signal {
            static let keyPath = "_property._value"
        }
        
        struct UISearchBarBinding {
            struct Text {
                static let keyPath = "searchBar._text"
            }
        }
    }
    
    struct HTTP {
        struct Errors {
            static let invalidRequest = NSError(domain: "localhost", code: -1, userInfo: ["message" : "an invalid request provided"])
        }
    }
}
