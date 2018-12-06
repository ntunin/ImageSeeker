//
//  Signal.swift
//  ImageSeeker
//
//  Created by ntunin on 05/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class Signal<T, Error>: NSObject {
    
    private weak var _property: MutableProperty<T>?
    
    var property: MutableProperty<T>?
    private var observers: [(Signal<T, Error>)->Void] = []
    
    override init() {
        super.init()
    }    
    
    func observe(_ callback: @escaping (Signal<T, Error>)->Void) {
        observers.append(callback)
    }
    
    func notifyAll() {
        for observer in observers {
            observer(self)
        }
    }
    
    func map<U>(_ transform: @escaping (T)->U) -> Signal<U, Error> {
        if let value = self.property?.value {
            let property = MutableProperty<U>(transform(value))
            observe { observer in
                if let value = self.property?.value {
                    property.value = transform(value)
                }
            }
            return property.signal as! Signal<U, Error>
        }
        return Signal<U, Error>()
    }
    
    func or(_ second: Signal<T, Error>) -> Signal<T, Error> {
        return logical(second) { first, second in first || second }
    }
    
    func and(_ second: Signal<T, Error>) -> Signal<T, Error> {
        return logical(second) { first, second in first && second }
    }
    
    private func logical(_ second: Signal<T, Error>, transform: @escaping (Bool, Bool) -> Bool) -> Signal<T, Error> {
        if let property1 = self.property,
            let property2 = second.property,
            let value1 = property1.value as? Bool,
            let value2 = property2.value as? Bool,
            let value = transform(value1, value2) as? T {
            let property = MutableProperty<T>(value)
            let observer = { (signal: Signal<T, Error>) in
                if let value1 = property1.value as? Bool,
                    let value2 = property2.value as? Bool,
                    let value = transform(value1, value2) as? T{
                    property.value =  value
                }
            }
            self.observe(observer)
            second.observe(observer)
            return property.signal as! Signal<T, Error>
        }
        return Signal<T, Error>()
    }
    
    
}
