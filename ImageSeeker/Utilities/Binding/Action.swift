//
//  Action.swift
//  ImageSeeker
//
//  Created by ntunin on 06/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class Action: NSObject {
    private let action: ()->Void
    
    init(_ action: @escaping ()->Void) {
        self.action = action
        super.init()
    }
    
    func apply() {
        action()
    }
}
