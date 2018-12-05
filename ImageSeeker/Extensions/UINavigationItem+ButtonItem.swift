//
//  UINavigationItem+RightButton.swift
//  ImageSeeker
//
//  Created by ntunin on 03/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    @IBInspectable var rightButtonWithImage: UIImage? {
        set {
            let button = UIBarButtonItem(image: newValue, style: .plain, target: self, action: #selector(onRightButtonClick))
            self.rightBarButtonItem = button
        }
        get {
            return self.rightBarButtonItem?.image
        }
    }
    
    @IBInspectable var leftButtonWithImage: UIImage? {
        set {
            let button = UIBarButtonItem(image: newValue, style: .plain, target: self, action: #selector(onLeftButtonClick))
            self.leftBarButtonItem = button
        }
        get {
            return self.leftBarButtonItem?.image
        }
    }
    
    @objc func onRightButtonClick() {
        NotificationCenter.default.post(name: K.Notifications.onRightNavigationButtonClick, object: self)
    }
    
    @objc func onLeftButtonClick() {
        NotificationCenter.default.post(name: K.Notifications.onLeftNavigationButtonClick, object: self)
    }
    
}
