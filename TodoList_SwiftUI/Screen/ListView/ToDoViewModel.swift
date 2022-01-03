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
    
    private var cancellable: Set<AnyCancellable> = []
        
    var isAlertError: Bool = false
    
    init() {
        selectedSegment()
    }
    
    /// Todoを全件取得する
    private func fetchAllTodoModel() -> Future<[ToDoModel], Never> {
        return Future<[ToDoModel], Never> { promise in
            promise(.success(ToDoModel.allFindTodo()))
        }
    }
    
    /// Todoを全件取得し、SegmentIndexの値によってフィルターをする
    func sinkAllTodoModel(index: SegmentIndex) {
        fetchAllTodoModel()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.objectWillChange.send()
                case .failure(_):
                    break
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
        self.objectWillChange.send()
    }
    
    
   
    /// segmentIndexが選択されたらTodoの全件取得をする
    private func selectedSegment() {
        $segmentIndex
            .print()
            .sink(receiveValue: { value in
                self.sinkAllTodoModel(index: value)
            })
        .store(in: &cancellable)
    }

}

