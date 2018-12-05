//
//  GET.swift
//  ImageSeeker
//
//  Created by ntunin on 05/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class GET: HTTPRequest {
    
    
    let urlRequest: URLRequest
    
    init(_ urlString: String) throws {
        if let url = URL(string: urlString) {
            urlRequest = URLRequest(url: url)
        } else {
            throw NSError(domain: "co.ntunin.imageseacker", code: -1, userInfo: ["message": "Could not create a url request"])
        }        
    }
    
    func getUrlRequest() -> URLRequest {
        return urlRequest
    }
    
    
}
