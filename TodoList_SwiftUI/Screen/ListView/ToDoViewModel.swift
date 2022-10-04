//
//  ToDoViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/09/21.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum SegmentIndex: Int, CaseIterable {
    case all = 0
    case active = 1
    case expired = 2
    case complete = 3
}


final class ToDoViewModel: ObservableObject {
    
    @Published var todoModel: [ToDoModel] = []
    
    @Published var segmentIndex: SegmentIndex = .all
        
    var isAlertError: Bool = false
    
    /// Todoを全件取得する
    @MainActor
    func fetchAllTodoModel() async {
        let model = ToDoModel.allFindTodo()
        switch segmentIndex {
        case .active:
            self.todoModel = model.filter {
                Format().dateFromString(string: $0.todoDate)! > Format().dateFormat() && $0.completionFlag != CompletionFlag.completion.rawValue
            }
        case .expired:
            self.todoModel = model.filter {
                $0.todoDate <= Format().stringFromDate(date: Date()) && $0.completionFlag != CompletionFlag.completion.rawValue
            }
        case .complete:
            self.todoModel = model.filter {
                $0.completionFlag == CompletionFlag.completion.rawValue
            }
        case .all:
            self.todoModel = model
        }
    }
    


    /// Todoの削除
    func deleteTodo(delete: ToDoModel) throws -> ToDoModel {
        do {
            try ToDoModel.delete(deleteTodo: delete)
            /// 呼び出し元のTodoがnilになるとクラッシュするのでToDoの削除後に空のTodoを入れて回避する
            return ToDoModel()
        } catch {
            if let _error = error as? DeleteError {
                throw _error
            }
            throw error
        }
    }
    
    /// Todoを全件削除する
    func allDeleteTodo() {
        ToDoModel.allDelete()
        self.todoModel = []
    }

}

