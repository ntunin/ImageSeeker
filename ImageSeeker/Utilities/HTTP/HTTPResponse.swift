//
//  HTTPResponseResult.swift
//  ImageSeeker
//
//  Created by ntunin on 05/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class HTTPResponse<T> {
    
    var value: T?
    var statusCode: Int = -1
    var error: Error?
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.value = parse(data)
        if let urlHttpResponse = urlResponse as? HTTPURLResponse {
            statusCode = urlHttpResponse.statusCode
        }
        self.error = error
    }
    
    func parse(_ data: Data?) -> T? {
        return nil
    }
}
