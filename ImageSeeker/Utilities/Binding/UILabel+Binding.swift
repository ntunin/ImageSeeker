//
//  UILabel+Binding.swift
//  ImageSeeker
//
//  Created by ntunin on 06/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class UILabelBinding: UIViewBinding {
    private let label: UILabel
    var text: MutableProperty<String>
    
    init(_ label: UILabel) {
        self.label = label
        self.text = MutableProperty<String>(label.text ?? "")
        super.init(label)
        self.text.signal.observe { signal in
            self.label.text = self.text.value
        }
    }
}

extension UILabel {
    static let labelBindingAccociation = ObjectAssociation<UILabelBinding>()
    
    override var binding: UILabelBinding {
        get {
            if let bindingInstance = UILabel.labelBindingAccociation[self] {
                return bindingInstance
            }
            let bindingInstace = UILabelBinding(self)
            UILabel.labelBindingAccociation[self] = bindingInstace
            return bindingInstace
        }
    }
}
