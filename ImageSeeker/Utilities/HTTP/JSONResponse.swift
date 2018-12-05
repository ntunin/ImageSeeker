//
//  JSONResponse.swift
//  ImageSeeker
//
//  Created by ntunin on 05/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class JSONResponse: HTTPResponse<[String: Any]> {
    
    override func parse(_ data: Data?) -> [String : Any]? {
        guard let data = data else {
            return [:]
        }
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return [:]
            }
            return dictionary
        } catch {
            return [:]
        }
    }
    
}

extension HTTPRequest {

    func responseJSON(_ callback: @escaping (HTTPResponse<[String: Any]>)->Void) {
        resumeDataDask { (data, response, error) in
            let response = JSONResponse(data: data, urlResponse: response, error: error)
            callback(response)
        }
    }

}
