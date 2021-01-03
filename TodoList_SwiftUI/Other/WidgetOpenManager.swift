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
    
    var nextTodo: ToDoModel!
    
    
    private let openedFromWidget = NotificationCenter.default.publisher(for: Notification.Name(rawValue: R.string.notifications.openedFromWidget()))
        .sink(receiveValue: { notification in
            shared.openTodoModal()
        })
    
    
    private func openTodoModal() {
        guard let _nextTodo = ToDoViewModel().findNextTodo() else {
            return
        }
        nextTodo = _nextTodo
        isOpneTodo = true
    }
    
}
