//
//  SearchItemCell.swift
//  ImageSeeker
//
//  Created by ntunin on 30/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import SDWebImage
import ReactiveSwift

class SearchItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var highlightView: UIView!
    
    var viewModel = SearchItemCellViewModel()
    
    override var isSelected: Bool {
        get {
            return viewModel.selected.value
        }
        set {
            viewModel.selected.value = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        highlightView.reactive.isHidden <~ viewModel.selected.map({ value in !value})
        viewModel.item.signal.observe { signal in
            self.updateContent()
        }
    }
    
    func configure(_ item: SearchImageItem?) {
        viewModel.item.value = item
    }
    
    func updateContent() {
        guard let item = self.viewModel.item.value,
            let thumbnailLink = item.thumbnailLink  else {
                self.imageView.image = self.imageView.placeholder
                return
        }
        self.imageView.sd_setImage(with: URL(string: thumbnailLink), placeholderImage: self.imageView.placeholder)
    }
}
