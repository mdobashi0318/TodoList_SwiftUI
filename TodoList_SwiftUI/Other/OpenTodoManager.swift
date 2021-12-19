//
//  WidgetOpneManager.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/12/28.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation


/// アプリ外でTodoを開いた時のTodoの設定をする
final class OpenTodoManager: ObservableObject {
    
    /// アプリ外でTodoを開いた際にどこから開いたかのenum
    enum OpenMethod {
        case Widget
        case NotificationBanner
    }
        
    static let shared = OpenTodoManager()
    
    @Published var isOpneTodo: Bool = false
    
    /// 詳細を開くTodo
    private(set) var openTodo: ToDoModel!
    
    /// 次に来るのTodoを検索する
    private var findNextTodo: ToDoModel? {
        get {
            let model = ToDoModel.allFindTodo()
            guard let _nextTodo = model.filter({ Format().dateFromString(string: $0.todoDate)! > Format().dateFormat() }).first,
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
    
    
    /// 詳細を開くTodoを設定する
    private func openTodoModal(_ open: OpenMethod, todo: ToDoModel?) {
        switch open {
        case .Widget:
            guard let _nextTodo = findNextTodo else {
                return
            }
            openTodo = _nextTodo
        case .NotificationBanner:
            guard let _openTodo = todo else {
                return
            }
            openTodo = _openTodo
        }
        isOpneTodo = true
    }
    
}
