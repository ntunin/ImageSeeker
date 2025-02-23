//
//  ImageSeekerTests.swift
//  ImageSeekerTests
//
//  Created by ntunin on 29/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import XCTest
@testable import ImageSeeker

class ImageSeekerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGoogleAPI() {
        let apiExpectation = expectation(description: "Wait while json api returns result")
        do {
            let api = try ImageSeekerGoogleAPI()
            api.getImages("monkeys", page: 1, count: 5) { items, count in
                assert(items?.count == 5)
                apiExpectation.fulfill()
            }
        } catch {
            assert(false)
        }
        wait(for: [apiExpectation], timeout: 20)
    }

    func testJSONAPI() {
        let apiExpectation = expectation(description: "Wait while json api returns result")
        do {
            let api = try ImageSeekerJSONAPI("response")
            api.getImages("monkeys", page: 1, count: 5) { items, count in
                assert(items?.count == 5)
                apiExpectation.fulfill()
            }
        } catch {
            assert(false)
        }
        wait(for: [apiExpectation], timeout: 20)
    }
    
    func testStorageManager() {
        let entity = SearchImageItem(title: "", link: "", thumbnailLink: "")
        PersistentContainerStorageManager.shared.insert(into: K.Storage.Tables.SearchImageItems, value: entity)
        guard let items = PersistentContainerStorageManager.shared.select(allFromTable: K.Storage.Tables.SearchImageItems) as? [SearchImageItem] else {
            assert(false)
        }
        assert(items.count > 0)
        PersistentContainerStorageManager.shared.delete(from: K.Storage.Tables.SearchImageItems, value: entity)
    }
    
    func testMapperWithString() {
        let response = PlistMapper().map("{ \"queries\": {\"request\": [{\"totalResults\": \"165\"}]} }", to: SearchImagesResponse.self) as? SearchImagesResponse
        assert(response?.totalCount == 165)
    }
    
    func testMapperWithDictionary() {
        if let url = Bundle.main.url(forResource: "response", withExtension: "json") {

            do {
                let data = try Data(contentsOf: url)
                guard let string = String(data: data, encoding: .utf8),
                    let response = PlistMapper().map(string, to: SearchImagesResponse.self) as? SearchImagesResponse,
                    let i = response.items else {
                        assert(false)
                    }
                assert(i[0].title == "Panama Monkeys Have Begun Using Rocks as Tools | Fortune")
            } catch {
                assert(false)
            }
        } else {
            assert(false)
        }
        
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
