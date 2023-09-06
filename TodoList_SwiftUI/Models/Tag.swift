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
        var configuration = Realm.Configuration()
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
    
    @Persisted var created_at: String
    
    @Persisted var updated_at: String
    
    static func add(name: String, color: CGColor) throws {
        let tag = Tag()
        let _created_at = Format.stringFromDate(date: Date(), addSec: .secnd)
        
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
        tag.created_at = _created_at
        tag.updated_at = _created_at
        
        
        do {
            try realm.write {
                realm.add(tag)
            }
        } catch {
            print("error: \(error)")
            throw error
        }
    }
    
    
    static func update(id: String, name: String, color: CGColor) throws {
        guard let realm,
              let tag = find(id: id),
              let components = color.components else {
            return
        }
        
        do {
            try realm.write {
                tag.name = name
                tag.red = components[0].description
                tag.green = components[1].description
                tag.blue = components[2].description
                tag.alpha = components[3].description
                tag.updated_at = Format.stringFromDate(date: Date(), addSec: .secnd)
            }
        } catch {
            print("error: \(error)")
            throw error
        }
    }
    
    
    
    static func delete(id: String) throws {
        guard let realm,
              let tag = find(id: id) else {
            throw TagModelError(message: "Tagの削除に失敗しました")
        }
        
        
        do {
            try realm.write {
                realm.delete(tag)
            }
        } catch {
            throw TagModelError(message: "Tagの削除に失敗しました")
        }
        
    }
    
    
    
    /// タグを全件取得する
    ///
    /// - Parameter addEmptyTagFlag: 空のタグを追加するかのフラグ
    /// - Returns: タグの配列を降順で返す
    static func findAll(addEmptyTagFlag: Bool = false) -> [Tag] {
        guard let realm else {
            return []
        }
        
        var model = [Tag]()
        
        if addEmptyTagFlag {
            model.append(Tag())
        }
        
        realm.objects(Tag.self).freeze().forEach {
            model.append($0)
        }
        
        
        model.sort {
            Format.dateFromString(string: $0.updated_at, addSec: .secnd)?.compare(Format.dateFromString(string: $1.updated_at, addSec: .secnd) ?? Date()) == .orderedDescending
        }
        
        return model
    }
    
    
    
    static func find(id: String) -> Tag? {
        guard let realm else {
            return nil
        }
        
        return (realm.object(ofType: Tag.self, forPrimaryKey: id))
    }
    
    
    func color() -> CGColor  {
        return CGColor(red: CGFloat(truncating:NumberFormatter().number(from: red) ?? 0.0),
                       green: CGFloat(truncating:NumberFormatter().number(from: green) ?? 0.0),
                       blue: CGFloat(truncating:NumberFormatter().number(from: blue) ?? 0.0),
                       alpha: CGFloat(truncating:NumberFormatter().number(from: alpha) ?? 0.0)
        )
    }
}




struct TagModelError: Error {
    var message: String
}




