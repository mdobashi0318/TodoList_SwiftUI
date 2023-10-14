//
//  StringExtension.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/08/17.
//

import Foundation


extension String {
    
    /// 文字列が空白かどうかを判定する
    func isSpace() -> Bool {
        self == " " || self == "　"
    }
}
