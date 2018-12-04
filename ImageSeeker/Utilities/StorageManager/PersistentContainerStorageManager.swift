//
//  StorageManager.swift
//  Skyper
//
//  Created by ntunin on 20.09.2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class PersistentContainerStorageManager: NSObject, StorageManager {
    
    static let shared = PersistentContainerStorageManager()
    public var mapInstances:[String: String] = [:]
    
    var container: NSPersistentContainer?
    
    override init() {
        super.init()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            container = appDelegate.persistentContainer
        }
    }
    
    
    func getManagedObjectContext() -> NSManagedObjectContext? {
        return container?.viewContext
    }
    
    
}
