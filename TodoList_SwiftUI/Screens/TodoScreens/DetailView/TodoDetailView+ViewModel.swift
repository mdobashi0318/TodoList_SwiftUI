//
//  TodoDetailViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2021/06/27.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import Foundation
import Observation

extension TodoDetailView {
    
    @Observable
    class ViewModel: ObservableObject {
        
        /// 完了フラグ
        ///
        /// 画面側でのトグルの選択された値
        var isCompletion: Bool = false {
            didSet {
                self.completionFlagStr = isCompletion ? .completion : .unfinished
                
                /// 新旧のcompletionFlagStrが一致していたら、モデルのフラグ更新処理を実行しない
                if self.model.completionFlag == self.completionFlagStr.rawValue { return }
                ToDoModel.updateCompletionFlag(updateTodo: self.model, flag: self.completionFlagStr)
            }
        }
        
        var isError: Bool = false
        
        private var model = ToDoModel()
        
        var title: String { model.toDoName }
        
        var date: String { model.todoDate }
        
        var detail: String { model.toDo }
        
        var completionFlag: String { model.completionFlag }
        
        var createTime: String { model.createTime ?? "" }
        
        var tagId: String? { model.tag_id }
        
        /// Model側に格納する完了フラグの文字列
        private var completionFlagStr: CompletionFlag = .unfinished
        
        private(set) var errorMessage: String = ""
        
        init(createTime: String) {
            findTodo(createTime: createTime)
            self.isCompletion = model.completionFlag == CompletionFlag.completion.rawValue ? true : false
        }
        
        
        /// Todoを１件検索
        func findTodo(createTime: String) {
            guard let model = ToDoModel.findTodo(createTime: createTime) else {
                isError = true
                errorMessage = R.string.message.findError()
                return
            }
            
            self.isCompletion = self.model.completionFlag == CompletionFlag.completion.rawValue ? true : false
            self.model = model
        }
        
        
        /// Todoの削除
        func deleteTodo() -> Bool {
            do {
                try ToDoModel.delete(deleteTodo: model)
                /// 呼び出し元のTodoがnilになるとクラッシュするのでToDoの削除後に空のTodoを入れて回避する
                self.model = ToDoModel()
                return true
            } catch {
                if error is DeleteError {
                    errorMessage = R.string.message.deleteError()
                    isError = true
                } else {
                    errorMessage = R.string.message.deleteError()
                    isError = true
                }
                return false
            }
        }
        
        
    }
}
