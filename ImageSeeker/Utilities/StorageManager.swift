//
//  StorageManager.swift
//  Skyper
//
//  Created by ntunin on 20.09.2018.
//  Copyright © 2018 ntunin. All rights reserved.
//

import UIKit
import CoreData


var persistentContainer: NSPersistentContainer?

class StorageManager: NSObject {
    static let shared = StorageManager()
    public var mapInstances:[String: String] = [:]
    
    private var mapConfig:[String: AnyObject]?
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: K.Storage.containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private override init() {
        super.init()
        self.mapConfig = getMapConfig()
        persistentContainer = container
    }
    
    private func getMapConfig()->[String: AnyObject]? {
        if let path = Bundle.main.path(forResource: "ClassMap", ofType: "plist"),
            let config = NSDictionary(contentsOfFile: path){
            return config as? [String: AnyObject]
        }
        return nil
    }
    
    public func select(allFromTable: String)->[Any]? {
        let request = getFetchRequest(allFromTable)
        return fetch(request)
    }
    
    public func select(allFromTable: String, Where: String)->[Any]? {
        let request = getFetchRequest(allFromTable)
        request.predicate = NSPredicate(format: Where)
        return fetch(request)
    }
    
    public func delete(from: String, value: Entity) {
        let context = persistentContainer!.viewContext
        guard let id = getObjectId(forEntity: value) else {
            return
        }
        let object = context.object(with: id)
        context.delete(object)
        do {
            try context.save()
        }catch {
            print("Could not delete the object", value)
        }
    }
    
    public func delete(from: String, values: [Entity]) {
        for value in values {
            delete(from: from, value: value)
        }
    }
    
    private func getObjectId(forEntity: Entity)->NSManagedObjectID? {
        guard let idString = forEntity.objectId else {
            return nil
        }
        let url = URL(string: idString)
        let context = persistentContainer!.viewContext
        let id = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url!)
        return id
    }
    
    private func getFetchRequest(_ tableName: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        return request
    }
    
    private func fetch(_ request: NSFetchRequest<NSFetchRequestResult>)->[Any]? {
        let context = persistentContainer!.viewContext
        do {
            let result = try context.fetch(request) as! [NSFetchRequestResult]
            return mapResult(result)
        } catch {
            return []
        }
    }
    
    
    private func mapResult(_ objects: [NSFetchRequestResult])->[Any] {
        if(objects.count == 0) {
            return []
        }
        let template = objects[0] as! NSManagedObject
        let tableType = type(of: template)
        let tableName = NSStringFromClass(tableType)
        let tablesConfig = mapConfig!["Table"] as! [String: AnyObject]
        let tableConfig = tablesConfig[tableName] as! [String: AnyObject]
        let className = tableConfig["Class"] as! String
        let map = tableConfig["Map"] as! [String: String]
        var result:[Any] = []
        guard let Class = NSClassFromString(className) as? Entity.Type else {
            return result
        }
        for fetchResult in objects {
            let data = fetchResult as! NSManagedObject
            let id = data.objectID.uriRepresentation().absoluteString
            let instance = Class.init(id)
            for tableKey in map.keys {
                let instanceKey = map[tableKey]
                let value = data.value(forKey: tableKey)
                instance.setValue(value, forKey: instanceKey!)
            }
            result.append(instance)
        }
        return result
    }
    
    public func insert(into: String, value: Entity) {
        let context = persistentContainer!.viewContext
        let entity = NSEntityDescription.entity(forEntityName: into, in: context)!
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        let classesConfig = mapConfig!["Class"] as! [String: AnyObject]
        let className = NSStringFromClass(type(of: value))
        let classConfig = classesConfig[className]as! [String: AnyObject]
        let map = classConfig["Map"] as! [String: String]
        for instanceKey in map.keys {
            let tableKey = map[instanceKey]
            let value = value.value(forKey: instanceKey)
            managedObject.setValue(value, forKey: tableKey!)
        }
        do {
            try context.save()
        }catch {
            print("Could not store the object", value)
        }
    }
    
    public func insert(into: String, values: [Entity]) {
        for value in values {
            insert(into: into, value: value)
        }
    }
}
