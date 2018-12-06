//
//  SearchViewModel.swift
//  ImageSeeker
//
//  Created by ntunin on 29/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

final class SearchViewModel {
    
    struct NoContentStub {
        let reason: String
        
        static let wrongKeywords = "Keywords string should contain at least 1 characters"
        static let validKeywords = "Keywords are acceptible. Tap 'Search' button to start"
    }
    
    struct Checks {
        static func isWrongKeyword(_ value: String) -> Bool{
            return value.count < 1
        }
    }
    
    var keywords: MutableProperty<String>
    var imageItems: MutableProperty<[SearchImageItem]>
    var selectedImageItems: MutableProperty<[SearchImageItem]>
    
    var areKeywordsWrong: Signal<Bool, Error>
    var noContentStub: Signal<String, Error>
    var isContentLoading: MutableProperty<Bool>
    var isContentLoaded: MutableProperty<Bool>
    var totalCount: MutableProperty<Int>
    var imagesReceiver: (([SearchImageItem]?, Int)->Void)?
    
    var search: Action?
    
    init() {
        keywords = MutableProperty("")
        imageItems = MutableProperty([])
        selectedImageItems = MutableProperty([])
        isContentLoading = MutableProperty(false)
        isContentLoaded = MutableProperty(false)
        totalCount = MutableProperty(0)
        areKeywordsWrong = keywords.signal.map({Checks.isWrongKeyword($0)})
        
        
        noContentStub = areKeywordsWrong.map({ value -> String in
            if value {
                return NoContentStub.wrongKeywords
            }
            return NoContentStub.validKeywords
        })
        keywords.signal.observe { signal in
            if Checks.isWrongKeyword(self.keywords.value) {
                ContentManager.shared.reset()
                self.imageItems.value.removeAll()
                self.isContentLoaded.value = false
                self.isContentLoading.value = false
                self.imagesReceiver = nil
            }
        }
        
        search = Action(loadNextPage)
        
    }
    
    func loadNextPage() {
        if Checks.isWrongKeyword(keywords.value){
            return
        }
        isContentLoading.value = true
        imagesReceiver = { items, count in
            self.isContentLoading.value = false
            guard let items = items else {
                return
            }
            if self.areKeywordsWrong.property?.value ?? false {
                return
            }
            self.imageItems.value.append(contentsOf: items)
            self.totalCount.value = count
            self.isContentLoaded.value = true
        }
        
        ContentManager.shared.loadNextPage(keywords.value){ items, count in
            if let imagesReceiver = self.imagesReceiver {
                imagesReceiver(items, count)
            }
        }
    }
        
    
}

