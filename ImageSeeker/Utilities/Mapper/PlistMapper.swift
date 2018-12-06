//
//  Mapper.swift
//  ImageSeeker
//
//  Created by ntunin on 05/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class Mapper<T: NSObject> {
    
    let pListMapper = PlistMapper()
    
    func map(_ json: [String: Any]) -> T? {
        return pListMapper.map(json, to: T.self) as? T
    }
    
    func map(_ jsonString: String) -> T? {
        return pListMapper.map(jsonString, to: T.self) as? T
    }
}

protocol Unwrapper {
    func unwrap(_ value: Any?, configs: [String: Any?]) -> Any?
}

class PlistMapper: NSObject {
    
    private let unwrappers: [String: Unwrapper] = [
        "Int": IntUnwrapper(),
        "Array": ArrayUnwrapper(),
        "String": StringUnwrapper()
    ]
    
    private var mapConfig: [String: AnyObject]? {
        get {
            if let path = Bundle.main.path(forResource: "ClassMap", ofType: "plist"),
                let config = NSDictionary(contentsOfFile: path){
                return config as? [String: AnyObject]
            }
            return nil
        }
    }
    
    
    func map(_ json: [String: Any], to missingClass: NSObject.Type) -> AnyObject? {
        let mappingClassName = NSStringFromClass(missingClass)
        if let mapConfig = mapConfig,
            let mapModelList = mapConfig["JSON"] as? [String: AnyObject],
            let mapModel = mapModelList[mappingClassName] as? [String: AnyObject] {
            let instance = missingClass.init()
            for key in mapModel.keys {
                if let keyMapConfig = mapModel[key] as? [String: AnyObject],
                    let keyPath = keyMapConfig["keyPath"] as? String {
                    let jsonValue = reach(keyPath, in: json)
                    let value = unwrap(jsonValue, config: keyMapConfig)
                    instance.setValue(value, forKey: key)
                }
            }
            return instance
        }
        return nil
    }
    
    func map(_ jsonString: String, to missingClass: NSObject.Type) -> AnyObject? {
        let json = self.json(jsonString)
        return map(json, to: missingClass)
    }
    
    private func json(_ jsonString: String) -> [String: Any] {
        do {
            if let data = jsonString.data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json
            } else {
                return [:]
            }
        } catch {
            return [:]
        }
    }
    
    private func unwrap(_ value: Any?, config: [String: AnyObject]) -> Any? {
        guard let value =  value,
            let type = config["type"] as? String,
            let unwrapper = unwrappers[type] else {
            return nil
        }
        return unwrapper.unwrap(value, configs: config)
    }
    
    private func reach(_ keyPath: String, in json: [String: Any]) -> Any? {
        let pathComponents = keyPath.split(separator: ".")
        var result: Any? = json
        for pathComponent in pathComponents {
            if let object = result as? [String: Any?] {
                let key = String(pathComponent)
                if let o = object[key] as Any? {
                    result = o
                } else {
                    result = nil
                }
            } else if let array = result as? [Any?] {
                let index = Int(pathComponent) ?? 0
                result = array[index]
            }
        }
        return result
    }

    func unwrapInt(_ value: Any?) -> Int {
        if let value = value as? Int {
            return value
        } else if let value = value as? String {
            return Int(value) ?? 0
        }
        return 0
    }
    
    class IntUnwrapper: Unwrapper {
        func unwrap(_ value: Any?, configs: [String: Any?]) -> Any? {
            if let value = value as? String {
                return Int(value) ?? 0
            }
            if let value = value as? Int {
                return value
            }
            return 0
        }
    }
    
    class StringUnwrapper: Unwrapper {
        func unwrap(_ value: Any?, configs: [String: Any?]) -> Any? {
            if let value = value as? String {
                return value
            }
            return nil
        }
    }
    
    class ArrayUnwrapper: Unwrapper {
        func unwrap(_ value: Any?, configs: [String: Any?]) -> Any? {
            if let itemConfig = configs["item"] as? [String: Any],
               let itemTypeName = itemConfig["type"] as? String,
               let itemType = NSClassFromString(itemTypeName) as? NSObject.Type,
               let jsonItems = value as? [Any?] {
                let mapper = PlistMapper()
                var result: [Any?] = []
                for jsonItem in jsonItems {
                    if let j = jsonItem as? [String: Any] {
                        let item = mapper.map(j, to: itemType)
                        result.append(item)
                    }
                }
                return result
            }
            return nil
        }
        
        //_TtGC11ImageSeeker6MapperCS_15SearchImageItem_
    }
}



