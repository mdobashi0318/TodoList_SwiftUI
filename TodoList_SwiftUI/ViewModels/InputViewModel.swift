//
//  InputViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2021/01/17.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import Foundation
import Combine

final class InputViewModel: ObservableObject {
    
    var id: String = ""
    
    /// Todoのタイトル
    @Published var toDoName: String = ""
    
    /// Todoの期限
    @Published var todoDateStr: String = ""
    
    /// Todoの期限
    @Published var toDoDate = Date()
    
    /// Todoの詳細
    @Published var toDo: String = ""
    
    @Published var completionFlag: Bool = false
    
    @Published var completionFlagStr: CompletionFlag = .unfinished
    
    var createTime: String?
    
    var cancellable: Set<AnyCancellable> = []
    
 

    init(model: ToDoModel? = nil) {
        setModelValue(model)
        setDatePub()
        setCompletionFlagPub()
    }
    
    
    private func setModelValue(_ model: ToDoModel?) {
        if let _model = model {
            id = _model.id
            toDoName = _model.toDoName
            todoDateStr = _model.todoDate
            if let date = Format().dateFromString(string: _model.todoDate) {
                toDoDate = date
            }
            toDo = _model.toDo
            completionFlag = _model.completionFlag == CompletionFlag.completion.rawValue ? true : false
            createTime = _model.createTime
        }
    }
    
    private func setDatePub() {
        $toDoDate
            .map { date in
                Format().stringFromDate(date: date)
            }
            .print()
            .sink(receiveValue: { toDoDate in
                self.todoDateStr = toDoDate
            })
            .store(in: &cancellable)
    }
    
    private func setCompletionFlagPub() {
        $completionFlag
            .print()
            .sink(receiveValue: { flag in
                self.completionFlagStr = flag ? .completion : .unfinished
            })
            .store(in: &cancellable)
    }
    
    
    /// Todoの追加
    func addTodo() -> Future<Void, TodoModelError> {
        return Future<Void, TodoModelError> { promiss in
            if let message = self.validateCheck() {
                return promiss(.failure(.init(message: message)))
            }
            
            ToDoModel.addRealm(addValue: ToDoModel(toDoName: self.toDoName, todoDate: self.todoDateStr, toDo: self.toDo)) { result in
                switch result {
                case .success(_):
                    return promiss(.success(Void()))
                case .failure(let error):
                    print(error.localizedDescription)
                    return promiss(.failure(.init(message: "Todoの追加に失敗しました")))
                }
            }
        }
    }
    
    
    
    func updateTodo() -> Future<Void, TodoModelError> {
        return Future<Void, TodoModelError> { promiss in
            if let message = self.validateCheck() {
                return promiss(.failure(.init(message: message)))
            }
            
            ToDoModel.updateRealm(updateTodo: ToDoModel(id: self.id,toDoName: self.toDoName, todoDate: self.todoDateStr, toDo: self.toDo, completionFlag: self.completionFlagStr.rawValue, createTime: self.createTime)) { result in
                switch result {
                case .success(_):
                    return promiss(.success(Void()))
                case .failure(let error):
                    print(error.localizedDescription)
                    return promiss(.failure(.init(message: "Todoの更新に失敗しました")))
                }
            }
        }
    }
    
    
    /// バリデーションチェック
    /// - Returns: エラー文も返す
    func validateCheck() -> String? {
        if self.toDoName.isEmpty {
            return  R.string.alertMessage.validate("タイトル")
        } else if self.todoDateStr <= Format().stringFromDate(date: Format().dateFormat()) {
            return R.string.alertMessage.validateDate()
        } else if self.toDo.isEmpty {
            return R.string.alertMessage.validate("詳細")
        } else {
            return nil
        }
    }
    
}
