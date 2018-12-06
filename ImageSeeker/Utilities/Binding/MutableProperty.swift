//
//  MutableProperty.swift
//  ImageSeeker
//
//  Created by ntunin on 05/12/2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit

class MutableProperty<T>: NSObject {

    private var _value: T
    
    var value: T {
        get {
            return _value
        }
        set {
            _value = newValue
            self.signal.notifyAll()
        }
    }
    
    var signal: Signal<T, Error>
    
    
    init(_ value: T) {
        self.signal = Signal<T, Error>()
        self._value = value
        super.init()
        self.signal.property = self
    }
    
    
    static func <~(lhs: MutableProperty<T>, rhs: MutableProperty<T>) {
        rhs.signal.observe { signal in
            lhs.value = rhs.value
        }
    }
    
    static func <~(lhs: MutableProperty<T>, rhs: Signal<T, Error>) {
        rhs.observe { signal in
            if let value = signal.property?.value {
                lhs.value = value
            }
        }
    }
    
    
}
