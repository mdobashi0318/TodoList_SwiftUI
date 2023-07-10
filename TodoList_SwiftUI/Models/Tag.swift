//
//  Tag.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/10.
//

import Foundation
import RealmSwift
import CoreGraphics



final class Tag: Object {
    
    private static var realm: Realm? {
        var configuration: Realm.Configuration
        configuration = Realm.Configuration()
        configuration.schemaVersion = UInt64(1)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.TodoList-SwiftUI")
        configuration.fileURL = url!.appendingPathComponent("tag.realm")
        return try? Realm(configuration: configuration)
    }
    
    @Persisted(primaryKey: true) var id: String
    
    @Persisted var name: String
    
    @Persisted var red: String
    
    @Persisted var green: String
    
    @Persisted var blue: String
    
    @Persisted var alpha: String
    
    
    static func add(name: String, color: CGColor) throws {
        let tag = Tag()
        
        guard let realm,
              let components = color.components else {
            return
        }
        
        tag.id = UUID().uuidString
        tag.name = name
        tag.red = components[0].description
        tag.green = components[1].description
        tag.blue = components[2].description
        tag.alpha = components[3].description
        
        
        do {
            try realm.write {
                realm.add(tag)
            }
        } catch {
            print("error: \(error)")
            throw error
        }
        

        
    }
    
    
    static func findAll() -> [Tag] {
        guard let realm else {
            return []
        }
        
        var model = [Tag]()
        
        realm.objects(Tag.self).forEach {
            model.append($0)
        }
        
        return model
    }
    
    
    
    static func find(id: String) -> Tag? {
        guard let realm else {
            return nil
        }
        
        return (realm.objects(Tag.self).filter("id == '\(id)'").first)
    }
    
    
    
}
