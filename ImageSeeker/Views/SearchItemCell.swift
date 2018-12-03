//
//  SearchItemCell.swift
//  ImageSeeker
//
//  Created by ntunin on 30/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import SDWebImage

class SearchItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
        
    private var imageItem: SearchImageItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ item: SearchImageItem?) {
        imageItem = item
        guard let item = item,
              let thumbnailLink = item.thumbnailLink  else {
            imageView.image = imageView.placeholder
            return
        }
        imageView.sd_setImage(with: URL(string: thumbnailLink), placeholderImage: imageView.placeholder)
    }
}
