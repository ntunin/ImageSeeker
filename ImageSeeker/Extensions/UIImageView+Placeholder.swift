//
//  UIImageView+Placeholder.swift
//  ImageSeeker
//
//  Created by ntunin on 03/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

extension UIImageView {
    
    static let placeholderAccociation = ObjectAssociation<UIImage>()

    @IBInspectable var placeholder: UIImage? {
        get {
            return UIImageView.placeholderAccociation[self]
        }
        set {
            UIImageView.placeholderAccociation[self] = newValue
        }
    }
}
