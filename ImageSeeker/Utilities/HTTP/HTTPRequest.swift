//
//  HTTPRequest.swift
//  ImageSeeker
//
//  Created by ntunin on 05/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

protocol HTTPRequest {
    func getUrlRequest() -> URLRequest?
}

extension HTTPRequest {
    
    func resumeDataDask(_ completionHandler: @escaping (Data?, URLResponse?, Error?)->Void) {
        if let urlRequest = getUrlRequest() {
            let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: completionHandler)
            task.resume()            
        } else {
            completionHandler(nil, nil, K.HTTP.Errors.invalidRequest)
        }
    }
}
