//
//  GalleryViewModel.swift
//  ImageSeeker
//
//  Created by ntunin on 04/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

final class GalleryViewModel {
    var imageItems: MutableProperty<[SearchImageItem]>
    var selectedImageItems: MutableProperty<[SearchImageItem]>
    
    init() {
        imageItems = MutableProperty([])
        selectedImageItems = MutableProperty([])
    }

}
