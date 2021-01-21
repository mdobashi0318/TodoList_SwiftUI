//
//  WidgetOpneManager.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/12/28.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

final class WidgetOpenManager: ObservableObject {
        
    static let shared = WidgetOpenManager()
    
    @Published var isOpneTodo: Bool = false
    
    private(set) var nextTodo: ToDoModel!
    
    /// 次に来るのTodoを検索する
    var findNextTodo: ToDoModel? {
        get {
            guard let model = ToDoModel.allFindRealm(),
                  let _nextTodo = model.filter({ Format().dateFromString(string: $0.todoDate)! > Format().dateFormat() }).first,
                  !_nextTodo.id.isEmpty else {
                return nil
            }
            return _nextTodo
        }
    }
    
    
    private let openedFromWidget = NotificationCenter.default.publisher(for: Notification.Name(rawValue: R.string.notifications.openedFromWidget()))
        .sink(receiveValue: { notification in
            shared.openTodoModal()
        })
    
    
    private func openTodoModal() {
        guard let _nextTodo = findNextTodo else {
            return
        }
        nextTodo = _nextTodo
        isOpneTodo = true
    }
    
}
