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
    case complete = 3
}


final class ToDoViewModel: ObservableObject {
    
    var todoModel: [ToDoModel] = []
    
    @Published var segmentIndex: SegmentIndex = .all
    
    var cancellable: Set<AnyCancellable> = []
        
    var isAlertError: Bool = false
    
    init() {
        setSegmentPub()
    }
    
    
    func fetchAllTodoModel() -> Future<[ToDoModel], TodoModelError> {
        return Future<[ToDoModel], TodoModelError> { promise in
            guard let model = ToDoModel.allFindTodo() else {
                promise(.failure(.init(isError: true)))
                return
            }
            promise(.success(model))
        }
    }
    
    
    func sinkAllTodoModel(index: SegmentIndex) {
        fetchAllTodoModel()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.objectWillChange.send()
                case .failure(let error):
                    self.isAlertError = error.isError
                }
            }, receiveValue: { model in
                switch index {
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
            })
            .cancel()
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
                self.sinkAllTodoModel(index: value)
            })
        .store(in: &cancellable)
    }

}

