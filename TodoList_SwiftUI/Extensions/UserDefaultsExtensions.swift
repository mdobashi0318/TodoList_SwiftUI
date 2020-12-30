//
//  UserDefaultsExtensions.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/12/30.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum Key: String {
        /// Realmのファイルバージョン
        ///
        ///  - Ver 1: Realmの保存場所にFileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.TodoList-SwiftUI")に移行
        case RealmFileVer = "RealmFileVer"
    }
    
    
    func setInt(key: Key, value: Int) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    
    func getInt(key: Key) -> Int {
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) as? Int else {
            return 0
        }
        return value
    }
    
}
