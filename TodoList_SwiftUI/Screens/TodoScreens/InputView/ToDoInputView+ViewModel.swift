//
//  InputViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2021/01/17.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import Foundation


extension ToDoInputView {
    
    final class ViewModel: ObservableObject {
        
        private var model: ToDoModel?
        
        /// Todoのタイトル
        @Published var toDoName: String = ""
        
        ///  画面側のTodoの期限
        @Published var toDoDate = Date()
        
        /// Todoの詳細
        @Published var toDo: String = ""
        
        /// TagのID
        @Published var tag_id: String = ""
        
        /// エラーメッセージ
        private(set) var errorMessage: String = ""
        
        /// Tagセクションの表示フラグ
        var isTagSection: Bool {
            tagList.isNotEmpty
        }
        
        private(set) var tagList: [Tag] = []
        
        
        init(createTime: String? = nil) {
            findTodo(createTime: createTime)
            setModelValue(model)
            
        }
        
        /// Todoを１件検索
        private func findTodo(createTime: String?) {
            guard let createTime,
                  let model = ToDoModel.findTodo(createTime: createTime) else {
                return
            }
            self.model = model
        }
        
        
        /// Modelから取得した値を書くプロパティにセットする
        private func setModelValue(_ model: ToDoModel?) {
            tagList = Tag.findAll(addEmptyTagFlag: true)
            
            if let model {
                toDoName = model.toDoName
                if let date = Format.dateFromString(string: model.todoDate) {
                    toDoDate = date
                }
                toDo = model.toDo
                tag_id = model.tag_id ?? ""
            }
        }
        
        /// Todoの追加
        func addTodo() -> Bool {
            if let message = self.validateCheck() {
                errorMessage = message
                return false
            }
            
            do {
                try ToDoModel.add(addValue: ToDoModel(toDoName: self.toDoName, todoDate: Format.stringFromDate(date: toDoDate), toDo: self.toDo, tag_id: self.tag_id))
                return true
            } catch {
                errorMessage = R.string.message.addError()
                return false
            }
        }
        
        
        /// Todoの更新
        func updateTodo() -> Bool {
            guard let model = model else {
                errorMessage = R.string.message.updateError()
                return false
            }
            
            if let message = self.validateCheck() {
                errorMessage = message
                return false
            }
            
            do {
                try ToDoModel.update(updateTodo: ToDoModel(toDoName: self.toDoName,
                                                           todoDate: Format.stringFromDate(date: toDoDate),
                                                           toDo: self.toDo,
                                                           completionFlag: model.completionFlag,
                                                           createTime: model.createTime,
                                                           tag_id: self.tag_id
                                                          ))
                return true
            } catch {
                errorMessage = R.string.message.updateError()
                return false
            }
        }
        
        
        /// バリデーションチェック
        /// - Returns: エラー文も返す
        private func validateCheck() -> String? {
            errorMessage = ""
            return if self.toDoName.isEmpty {
                R.string.message.validate(R.string.labels.title())
            } else if Format.stringFromDate(date: toDoDate) <= Format.stringFromDate(date: Format.dateFormat()) {
                /// 完了フラグの未完であればあれば期限のバリデーションチェックを行う
                R.string.message.validateDate()
            } else {
                nil
            }
        }
        
    }
    
}
