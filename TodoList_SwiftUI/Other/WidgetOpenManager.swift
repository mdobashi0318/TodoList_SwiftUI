//
//  WidgetOpneManager.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/12/28.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

final class WidgetOpenManager: ObservableObject {
    
    enum OpenTodo {
        case Widget
        case NotificationBanner
    }
        
    static let shared = WidgetOpenManager()
    
    @Published var isOpneTodo: Bool = false
    
    private(set) var nextTodo: ToDoModel!
    
    /// 次に来るのTodoを検索する
    var findNextTodo: ToDoModel? {
        get {
            guard let model = ToDoModel.allFindTodo(),
                  let _nextTodo = model.filter({ Format().dateFromString(string: $0.todoDate)! > Format().dateFormat() }).first,
                  !_nextTodo.id.isEmpty else {
                return nil
            }
            return _nextTodo
        }
    }
    
    /// WidgetからTodoを開く
    private let openedFromWidget = NotificationCenter.default.publisher(for: Notification.Name(rawValue: R.string.notifications.openedFromWidget()))
        .sink(receiveValue: { _ in
            shared.openTodoModal(.Widget, todo: nil)
        })
    
    
    /// 通知からTodoを開く
    private let openedFromNotificationBanner = NotificationCenter.default.publisher(for: Notification.Name(rawValue: R.string.notifications.tapNotificationBanner()))
        .sink(receiveValue: { notification in
            guard let _id = notification.object as? String else { return }
            shared.openTodoModal(.NotificationBanner, todo: ToDoModel.findTodo(todoId: "", createTime: _id))
        })
    
    
    private func openTodoModal(_ open: OpenTodo, todo: ToDoModel?) {
        switch open {
        case .Widget:
            guard let _nextTodo = findNextTodo else {
                return
            }
            nextTodo = _nextTodo
        case .NotificationBanner:
            guard let _openTodo = todo else {
                return
            }
            nextTodo = _openTodo
        }
        isOpneTodo = true
    }
    
}
