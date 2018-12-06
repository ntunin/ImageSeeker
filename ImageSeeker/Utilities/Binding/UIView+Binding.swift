//
//  UIView+Binding.swift
//  ImageSeeker
//
//  Created by ntunin on 06/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class UIViewBinding: NSObject {
    let isHidden: MutableProperty<Bool>
    private let view: UIView
    
    init(_ view: UIView) {
        self.view = view
        isHidden = MutableProperty<Bool>(view.isHidden)
        super.init()
        isHidden.signal.observe { signal in
            self.view.isHidden = self.isHidden.value
        }
    }
}

extension UIView {
    static let viewBindingAccociation = ObjectAssociation<UIViewBinding>()
    
    @objc var binding: UIViewBinding {
        get {
            if let bindingInstance = UIView.viewBindingAccociation[self] {
                return bindingInstance
            }
            let bindingInstace = UIViewBinding(self)
            UIView.viewBindingAccociation[self] = bindingInstace
            return bindingInstace
        }
    }
}
