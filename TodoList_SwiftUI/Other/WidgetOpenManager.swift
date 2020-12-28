//
//  WidgetOpneManager.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/12/28.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

final class WidgetOpenManager: ObservableObject {
        
    var isOpneTodo: Bool = false
    
    var nextTodo: ToDoModel!
    
    init() {
        setNotificationCenter()
    }
    
    /// NotificationCenterを追加する
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didTapWidgetTodo(notification:)), name: NSNotification.Name(rawValue: R.string.notifications.opneTodo()), object: nil)
    }
    
    @objc private func didTapWidgetTodo(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.openTodoModal()
        }
    }
    
    private func openTodoModal() {
        guard let _nextTodo = ToDoViewModel().findNextTodo() else {
            return
        }
        nextTodo = _nextTodo
        isOpneTodo = true
        objectWillChange.send()
    }
    
    
    func closeTodoModal() {
        isOpneTodo = false
        objectWillChange.send()
    }
    
}
