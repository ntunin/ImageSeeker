//
//  ImageSeekerAPI.swift
//  ImageSeeker
//
//  Created by ntunin on 29/11/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

protocol ImageSeekerAPI {
    func getImages(_ query: String, page: Int, count: Int, callback: @escaping ([SearchImageItem]?, Int)->Void)
}
