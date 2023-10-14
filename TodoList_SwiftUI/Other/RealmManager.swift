//
//  RealmManager.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/09/26.
//

import Foundation
import RealmSwift

struct RealmManager {
    
    static let realm: Realm? = {
        var configuration = Realm.Configuration()
        configuration.schemaVersion = UInt64(2)
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.TodoList-SwiftUI") else { return nil }
        configuration.fileURL = url.appendingPathComponent("db.realm")
        return try? Realm(configuration: configuration)
    }()
    
}
