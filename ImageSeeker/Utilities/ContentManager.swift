//
//  ContentManager.swift
//  ImageSeeker
//
//  Created by ntunin on 30/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class ContentManager: NSObject {
    
    let api: ImageSeekerAPI?
    var storageManager: StorageManager?
    var page = 1
    var pageSize = 10
    
    static let shared = ContentManager()

    override init() {
        do {
            api = try ImageSeekerGoogleAPI()
            if #available(iOS 10.0, *) {
                storageManager = PersistentContainerStorageManager()
            } else {
                storageManager = PersistentStoreCoordinatorStorageManager()
            }
        } catch {
            api = nil
            print("could not initialize api service")
        }
    }
    
    func loadNextPage(_ query: String, callback: @escaping ([SearchImageItem]?, Int) -> Void) {
        DispatchQueue.global().async {
            self.api?.getImages(query, page: self.page, count: self.pageSize) { (items, count) in
                DispatchQueue.main.async {
                    callback(items, count)
                    self.page += 1
                }
            }
        }
    }
    
    func save(_ items: [SearchImageItem]) {
        if let storageManager = storageManager {
            storageManager.insert(into: K.Storage.Tables.SearchImageItems, values: items)            
        }
    }
    
    func load() -> [SearchImageItem] {
        guard let storageManager = storageManager,
            let items = storageManager.select(allFromTable: K.Storage.Tables.SearchImageItems) as? [SearchImageItem] else {
            return []
        }
        return items
    }
    
    func remove(_ items: [SearchImageItem]) {
        if let storageManager = storageManager {
            storageManager.delete(from: K.Storage.Tables.SearchImageItems, values: items)
        }
    }
    
    func reset() {
        page = 1
    }
    
    func loadImage(_ urlString: String, callback: @escaping (UIImage?)->Void) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString) {
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        callback(image)
                    }
                } catch {
                    callback(nil)
                }
            }
        }
        
    }
    
}
