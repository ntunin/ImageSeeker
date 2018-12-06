//
//  UIImageView+RemoteURL.swift
//  ImageSeeker
//
//  Created by ntunin on 05/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

extension UIImageView {
    
    static let cache = NSCache<NSString, UIImage>()
    
    func loadUrl(_ stringURL: String) {
        loadUrl(stringURL, placeholder: nil, completionHandler: {})
    }
    
    func loadUrl(_ stringURL: String, placeholder: UIImage?) {
        loadUrl(stringURL, placeholder: placeholder, completionHandler: {})
    }
    
    func loadUrl(_ stringURL: String, placeholder: UIImage?, completionHandler: @escaping ()->Void) {
        if let preloadedImage = UIImageView.cache.object(forKey: stringURL as NSString) {
            self.image = preloadedImage
            completionHandler()
            return
        }
        
        self.image = placeholder
        DispatchQueue.global().async {
            do {
                if let url = URL(string: stringURL) {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            self.image = image
                            UIImageView.cache.setObject(image, forKey: stringURL as NSString)
                        }
                        completionHandler()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler()
                }
            }
        }
    }
    
    
}
