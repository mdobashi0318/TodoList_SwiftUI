//
//  EditTagViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/13.
//

import Foundation
import CoreGraphics


extension EditTagView {
    
    class ViewModel: ObservableObject {
        
        @Published var tag: Tag
        
        @Published var color: CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        @Published var name = ""
        
        
        init(_ tag: Tag) {
            self.tag = tag
            self.color = tag.color()
            self.name = tag.name
        }
        
        /// 編集前に戻す
        func rollback() {
            self.tag = tag
            self.color = tag.color()
            self.name = tag.name
        }
        
        /// 更新
        func update() throws {
            do {
                if name.isEmpty || name.isSpace() {
                    throw TagModelError(message: R.string.message.inputTag())
                }
                try Tag.update(id: tag.id, name: name, color: color)
            } catch {
                throw TagModelError(message: R.string.message.tagEditError())
            }
        }
        
        /// 削除
        func delete() throws {
            do {
                try Tag.delete(id: tag.id)
            } catch {
                throw TagModelError(message: R.string.message.tagDeleteError())
            }
        }
    }
    
}
