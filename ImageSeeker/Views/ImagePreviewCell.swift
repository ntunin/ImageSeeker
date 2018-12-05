//
//  ImagePreviewCell.swift
//  ImageSeeker
//
//  Created by ntunin on 03/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class ImagePreviewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var item: SearchImageItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ item: SearchImageItem?) {
        self.item = item
        guard let item = item,
            let imageLink = item.link,
            let thumbnailLink = item.thumbnailLink else {
                imageView.image = imageView.placeholder
                return
        }
        imageView.loadUrl(thumbnailLink, placeholder: imageView.placeholder) //Just display thumbnail before loading image
        DispatchQueue.main.async {
            self.imageView.loadUrl(imageLink, placeholder: self.imageView.placeholder)
        }
    }

}
