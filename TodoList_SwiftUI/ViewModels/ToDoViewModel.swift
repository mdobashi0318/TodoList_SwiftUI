//
//  ToDoViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/09/21.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

enum SegmentIndex: Int, CaseIterable {
    case all = 0
    case active = 1
    case expired = 2
}


final class ToDoViewModel: ObservableObject {
    
    var todoModel: [ToDoModel]!
    
    var segmentIndex: SegmentIndex = .all
    
    @discardableResult
    func find(index: SegmentIndex = .all) -> [ToDoModel] {
        segmentIndex = index
        
        guard let model = ToDoModel.allFindRealm() else {
            return []
        }
        
        switch index {
        case .active:
            todoModel = model.filter {
                Format().dateFromString(string: $0.todoDate)! > Format().dateFormat()
            }
        case .expired:
            todoModel = model.filter {
                $0.todoDate <= Format().stringFromDate(date: Date())
            }
        default:
            todoModel = model
        }
        
        return todoModel
    }
    
    
    /// Todoを１件検索
    func findTodo(todoId: String, createTime: String) -> ToDoModel {
        let model = ToDoModel.findRealm(todoId: todoId, createTime: createTime)
        let todo = ToDoModel()
        todo.id = model?.id ?? ""
        todo.toDoName = model?.toDoName ?? ""
        todo.todoDate = model?.todoDate ?? ""
        todo.toDo = model?.toDo ?? ""
        
        return todo
    }
    
    
    /// Todoの追加
    func addTodo(add: ToDoModel?, success: ()->()?, failure: @escaping (String?)->()) {
        guard let _add = add else {
            return failure("Todoの追加に失敗しました")
        }
        
        ToDoModel.addRealm(addValue: _add) { error in
            if let _error = error {
                print(_error)
                failure("Todoの追加に失敗しました")
            } else {
                find(index: segmentIndex)
                self.objectWillChange.send()
                success()
            }
        }
    }
    
    
    /// Todoの更新
    func updateTodo(update: ToDoModel, success: () -> (), failure: @escaping (String?)->()) {
        ToDoModel.updateRealm(updateTodo: update, result: { error in
            if let _error = error {
                failure(_error)
                return
            }
            
            todoModel = ToDoModel.allFindRealm()!
            self.objectWillChange.send()
            success()
        })
    }
    
    
    
    
    /// Todoの削除
    func deleteTodo(todoId: String, createTime: String, success: (ToDoModel) -> (), failure: @escaping (String?)->()) {
        ToDoModel.deleteRealm(todoId: todoId, createTime: createTime) { error in
            
            if let _error = error {
                failure(_error)
                return
            }
            todoModel = ToDoModel.allFindRealm()!
            /// 呼び出し元のTodoがnilになるとクラッシュするのでToDoの削除後に空のTodoを入れて回避する
            success(ToDoModel(id: "", toDoName: "", todoDate: "", toDo: "", createTime: ""))
            self.objectWillChange.send()
        }
    }
    
    
    func allDeleteTodo() {
        ToDoModel.allDelete()
        todoModel = ToDoModel.allFindRealm()!
        self.objectWillChange.send()
    }
    
    
    /// Realmのモデルを参照しない時はTestデータの配列を使う
//    @Published var todoModel: [ToDoModel] = todomodel

}

