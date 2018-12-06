//
//  UIButtonBinding.swift
//  ImageSeeker
//
//  Created by ntunin on 06/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class UIButtonBinding: UIViewBinding {
    private let button: UIButton
    let isEnabled: MutableProperty<Bool>
    var pressed: Action?
    
    init(_ button: UIButton) {
        self.button = button
        self.isEnabled = MutableProperty<Bool>(button.isEnabled)
        super.init(button)
        self.isEnabled.signal.observe { signal in
            if let value = signal.property?.value {
                self.button.isEnabled = value
            }
        }
        self.button.addTarget(self, action: #selector(onButtonPress), for: .touchUpInside)
    }
    
    @objc func onButtonPress() {
        if let pressed = pressed {
            pressed.apply()
        }
    }
    
}

extension UIButton {
    static let buttonBindingAccociation = ObjectAssociation<UIButtonBinding>()
    
    override var binding: UIButtonBinding {
        get {
            if let bindingInstance = UIButton.buttonBindingAccociation[self] {
                return bindingInstance
            }
            let bindingInstace = UIButtonBinding(self)
            UIButton.buttonBindingAccociation[self] = bindingInstace
            return bindingInstace
        }
    }
    
}
