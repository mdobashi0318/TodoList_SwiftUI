//
//  EditTagViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/13.
//

import Foundation
import CoreGraphics
import Observation


extension EditTagView {
    
    @Observable
    class ViewModel {
        
        var tag: Tag
        
        var color: CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        var name = ""
        
        /// Alertの表示フラグ
        var isShowAlert = false
        
        private(set) var errorMessage = ""
        
        
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
        func update() {
            do {
                if name.isEmpty || name.isSpace() {
                    throw TagModelError(message: R.string.message.inputTag())
                }
                try Tag.update(id: tag.id, name: name, color: color)
            } catch {
                isShowAlert = true
                errorMessage = R.string.message.tagEditError()
            }
        }
        
        /// 削除
        func delete() {
            do {
                try Tag.delete(id: tag.id)
            } catch {
                isShowAlert = true
                errorMessage = R.string.message.tagDeleteError()
            }
        }
    }
    
}
