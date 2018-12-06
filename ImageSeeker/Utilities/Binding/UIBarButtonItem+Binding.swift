//
//  UIBarButtonItem+Binding.swift
//  ImageSeeker
//
//  Created by ntunin on 06/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class UIBarButtonItemBinding {
    let buttonItem: UIBarButtonItem
    let isEnabled: MutableProperty<Bool>
    
    init(_ buttonItem: UIBarButtonItem) {
        self.buttonItem = buttonItem
        isEnabled = MutableProperty<Bool>(buttonItem.isEnabled)
        isEnabled.signal.observe { signal in
            self.buttonItem.isEnabled = self.isEnabled.value
        }
    }
}

extension UIBarButtonItem {
    static let barButtonItemBindingAccociation = ObjectAssociation<UIBarButtonItemBinding>()
    
    var binding: UIBarButtonItemBinding {
        get {
            if let bindingInstance = UIBarButtonItem.barButtonItemBindingAccociation[self] {
                return bindingInstance
            }
            let bindingInstace = UIBarButtonItemBinding(self)
            UIBarButtonItem.barButtonItemBindingAccociation[self] = bindingInstace
            return bindingInstace
        }
    }
}
