//
//  UISearchBar+Binding.swift
//  ImageSeeker
//
//  Created by ntunin on 06/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class UISearchBarBinding: UIViewBinding, UISearchBarDelegate {
    
    @objc private let searchBar: UISearchBar
    var text: MutableProperty<String>
    var searchPressed: Action?
    
    init(_ aSearchBar: UISearchBar) {
        self.searchBar = aSearchBar
        self.text = MutableProperty<String>(searchBar.text ?? "")
        super.init(searchBar)
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.text.value = searchBar.text ?? ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let pressed = searchPressed {
            pressed.apply()
        }
    }
    
}


extension UISearchBar {
    static let searchBarBindingAccociation = ObjectAssociation<UISearchBarBinding>()
    static let searchBarTextAccociation = ObjectAssociation<String>()
    
    override var binding: UISearchBarBinding {
        get {
            if let bindingInstance = UISearchBar.searchBarBindingAccociation[self] {
                return bindingInstance
            }
            let bindingInstace = UISearchBarBinding(self)
            UISearchBar.searchBarBindingAccociation[self] = bindingInstace
            return bindingInstace
        }
    }
    
    
    
}
