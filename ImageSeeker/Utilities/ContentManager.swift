//
//  ContentManager.swift
//  ImageSeeker
//
//  Created by ntunin on 30/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class ContentManager: NSObject {
    
    let api: ImageSeekerAPI?
    var page = 1
    var pageSize = 50
    
    static let shared = ContentManager()

    override init() {
        do {
            api = try ImageSeekerJSONAPI("response")
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
        StorageManager.shared.insert(into: K.Storage.Tables.SearchImageItems, values: items)
    }
    
    func reset() {
        page = 1
    }
    
}
