//
//  GET.swift
//  ImageSeeker
//
//  Created by ntunin on 05/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class GET: HTTPRequest {
    
    
    private var urlRequest: URLRequest?
    
    init(_ urlString: String) {
        if let url = URL(string: urlString) {
            urlRequest = URLRequest(url: url)
        }
    }
    
    func getUrlRequest() -> URLRequest? {
        return urlRequest
    }
    
    
}
