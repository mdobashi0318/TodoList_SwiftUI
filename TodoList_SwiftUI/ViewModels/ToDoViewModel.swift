//
//  ToDoViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/09/21.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import Combine

enum SegmentIndex: Int, CaseIterable {
    case all = 0
    case active = 1
    case expired = 2
}


final class ToDoViewModel: ObservableObject {
    
    var todoModel: [ToDoModel] = []
    
    @Published var segmentIndex: SegmentIndex = .all
    
    var cancellable: Set<AnyCancellable> = []
        
    var isAlertError: Bool = false
    
    init() {
        setSegmentPub()
    }
    
    @discardableResult
    func find(index: SegmentIndex = .all) -> [ToDoModel] {
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
    
    
    
    func fetchAllTodoModel() -> Future<[ToDoModel], TodoModelError> {
        return Future<[ToDoModel], TodoModelError> { promise in
            guard let model = ToDoModel.allFindRealm() else {
                promise(.failure(.init(isError: true)))
                return
            }
            promise(.success(model))
        }
    }
    
    
    func sinkAllTodoModel() {
        fetchAllTodoModel()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.objectWillChange.send()
                case .failure(let error):
                    self.isAlertError = error.isError
                }
            }, receiveValue: { model in
                self.todoModel = model
            })
            .cancel()
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
    
    
    /// 次に来るのTodoを検索する
    func findNextTodo() -> ToDoModel? {
        guard let nextTodo = find(index: .active).first,
              !nextTodo.id.isEmpty else {
            return nil
        }
        return nextTodo
    }
    
    
 
  
    
    /// Todoの削除
    func deleteTodo(delete: ToDoModel) -> Future<ToDoModel, DeleteError> {
        return Future<ToDoModel, DeleteError> { promiss in
            ToDoModel.deleteRealm(deleteTodo: delete) { result in
                switch result {
                case .success(_):
                    /// 呼び出し元のTodoがnilになるとクラッシュするのでToDoの削除後に空のTodoを入れて回避する
                    return promiss(.success(ToDoModel()))
                case .failure(let error):
                    print(error)
                    return promiss(.failure(.init(model: delete, message: "Todoの削除に失敗しました")))
                }
            }
        }
    }
    
    
    func allDeleteTodo() {
        ToDoModel.allDelete()
        self.todoModel = []
        self.objectWillChange.send()
    }
    
    
   

    private func setSegmentPub() {
        $segmentIndex
            .print()
            .sink(receiveValue: { value in
            self.sinkAllTodoModel()
            switch value {
            case .active:
                self.todoModel = self.todoModel.filter {
                    Format().dateFromString(string: $0.todoDate)! > Format().dateFormat()
                }
            case .expired:
                self.todoModel = self.todoModel.filter {
                    $0.todoDate <= Format().stringFromDate(date: Date())
                }
            case .all:
                break
            }
        })
        .store(in: &cancellable)
    }

}

