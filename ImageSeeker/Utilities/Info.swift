//
//  Info.swift
//  ImageSeeker
//
//  Created by ntunin on 29/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class Info: NSObject {
    
    static var plist: NSDictionary? {
        get {
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                return NSDictionary(contentsOfFile: path)
            }
            return nil
        }
    }
    
}
