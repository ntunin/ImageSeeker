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
            leftBarButtonItem = button
        }
        get {
            return self.leftBarButtonItem?.image
        }
    }
    
    @IBInspectable var backButtonWithImage: UIImage? {
        set {
            let button = UIBarButtonItem(image: newValue, style: .plain, target: self, action: #selector(onLeftButtonClick))
            self.backBarButtonItem = button
        }
        get {
            return self.leftBarButtonItem?.image
        }
    }
    
    @IBInspectable var leftSpace: CGFloat {
        set {
            if let item = leftBarButtonItem {
                item.imageInsets = UIEdgeInsets(top: 0, left: newValue, bottom: 0, right: 0)
            }
        }
        get {
            return 0
        }
    }
    
    func addLeftItem(_ item: UIBarButtonItem) {
        if leftBarButtonItems == nil {
            leftBarButtonItems = []
        }
        leftBarButtonItems?.append(item)
    }
    
    @objc func onRightButtonClick() {
        NotificationCenter.default.post(name: K.Notifications.onRightNavigationButtonClick, object: self)
    }
    
    @objc func onLeftButtonClick() {
        NotificationCenter.default.post(name: K.Notifications.onLeftNavigationButtonClick, object: self)
    }
    
}
