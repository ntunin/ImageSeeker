//
//  UICollectionView+registerCellWithNibName.swift
//  ImageSeeker
//
//  Created by ntunin on 03/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

extension UICollectionView {

    static let nibNameAccociation = ObjectAssociation<String>()
    
    @IBInspectable var registeredNibName: String? {
        get {
            return UICollectionView.nibNameAccociation[self]
        }
        set {
            guard let nibName = newValue,
                let nibItems = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil),
                let cell = nibItems[0] as? UICollectionViewCell,
                let reuseIdentifier = cell.reuseIdentifier else {
                return
            }
            UICollectionView.nibNameAccociation[self] = reuseIdentifier
            let nib = UINib(nibName: nibName, bundle: nil)
            self.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    
    func registeredCell(_ forRowAt: IndexPath) -> UICollectionViewCell? {
        guard  let reuseIdentifier = registeredNibName else {
            return nil
        }
        return self.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: forRowAt)
    }
}
