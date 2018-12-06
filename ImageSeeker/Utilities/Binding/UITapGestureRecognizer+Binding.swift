//
//  UITapGestureRecognizer+Binding.swift
//  ImageSeeker
//
//  Created by ntunin on 06/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class UITapGestureRecognizerBinding {
    private let gesture: UITapGestureRecognizer
    var tap: Action?
    
    init(_ gesture: UITapGestureRecognizer) {
        self.gesture = gesture
        gesture.addTarget(self, action: #selector(onTap))
    }
    
    @objc private func onTap() {
        if let tap = tap {
            tap.apply()
        }
    }
}

extension UITapGestureRecognizer {
    static let gestureBindingAccociation = ObjectAssociation<UITapGestureRecognizerBinding>()
    
    var binding: UITapGestureRecognizerBinding {
        get {
            if let bindingInstance = UITapGestureRecognizer.gestureBindingAccociation[self] {
                return bindingInstance
            }
            let bindingInstace = UITapGestureRecognizerBinding(self)
            UITapGestureRecognizer.gestureBindingAccociation[self] = bindingInstace
            return bindingInstace
        }
    }
}
