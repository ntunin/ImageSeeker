//
//  SearchItemCellViewModel.swift
//  ImageSeeker
//
//  Created by ntunin on 03/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

final class SearchItemCellViewModel {
    var item: MutableProperty<SearchImageItem?>
    var selected: MutableProperty<Bool>
    
    init() {
        item = MutableProperty(nil)
        selected = MutableProperty(false)
    }
}
