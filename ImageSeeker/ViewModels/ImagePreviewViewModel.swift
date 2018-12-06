//
//  ImagePreviewViewModel.swift
//  ImageSeeker
//
//  Created by ntunin on 03/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

final class ImagePreviewViewModel {
    var imageItems: MutableProperty<[SearchImageItem]>?
    var index: MutableProperty<Int>
    var initialFrame: CGRect
    
    init() {
        imageItems = MutableProperty([])
        index = MutableProperty(0)
        initialFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    func prevIndex() {
        if index.value > 0 {
            index.value -= 1
        }
    }
    
    func nextIndex() {
        if index.value < (imageItems?.value.count ?? 0) - 1 {
            index.value += 1
        }
    }
}
