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
            let imageLink = item.link  else {
                imageView.image = imageView.placeholder
                return
        }
        imageView.sd_setImage(with: URL(string: imageLink), placeholderImage: imageView.placeholder)
    }

}
