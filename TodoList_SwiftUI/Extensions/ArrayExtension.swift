//
//  ArrayExtension.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2024/05/08.
//

import Foundation

extension Array where Element == Tag {
    /// 表示できるタグがあるかを判定し結果を返す
    /// - Returns: tagModelには空のタグが入っているので一つより多く入っていればtrueを返す
    var isNotEmpty: Bool {
        self.count > 1
    }
}
