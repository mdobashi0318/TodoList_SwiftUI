//
//  EditTagViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/13.
//

import Foundation
import CoreGraphics


class EditTagViewModel: ObservableObject {
    
    @Published var tag: Tag
    
    @Published var color: CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    @Published var name = ""
    
        
    init(_ tag: Tag) {
        self.tag = tag
        self.color = tag.color()
        self.name = tag.name
    }
    
    func rollback() {
        self.tag = tag
        self.color = tag.color()
        self.name = tag.name
    }
    
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
    
    
    func delete() throws {
        do {
            try Tag.delete(id: tag.id)
        } catch {
            throw TagModelError(message: R.string.message.tagDeleteError())
        }
    }
    
}
