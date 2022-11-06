//
//  TodoDetailViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2021/06/27.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import Foundation
import Combine


class TodoDetailViewModel: ObservableObject {
    
    var model: ToDoModel
        
    /// 完了フラグ
    ///
    /// 画面側でのトグルの選択された値
    @Published var completionFlag: Bool = false {
        didSet {
            self.completionFlagStr = completionFlag ? .completion : .unfinished
            
            /// 新旧のcompletionFlagStrが一致していたら、モデルのフラグ更新処理を実行しない
            if self.model.completionFlag == self.completionFlagStr.rawValue { return }
            ToDoModel.updateCompletionFlag(updateTodo: self.model, flag: self.completionFlagStr)
        }
    }
    
    /// Model側に格納する完了フラグの文字列
    private(set) var completionFlagStr: CompletionFlag = .unfinished
        
    @Published var isError: Bool = false
    
    var errorMessage: String = ""
    
    private var cancellable: Set<AnyCancellable> = []
    
    init(model: ToDoModel) { 
        self.model = model
        self.completionFlag = model.completionFlag == CompletionFlag.completion.rawValue ? true : false
    }
    
    
    /// Todoを１件検索
    func findTodo() {
        guard let model = ToDoModel.findTodo(todoId: model.id, createTime: model.createTime) else {
            isError = true
            errorMessage = R.string.message.findError()
            return
        }
        
        let todo = model
        self.completionFlag = self.model.completionFlag == CompletionFlag.completion.rawValue ? true : false
        self.model = todo
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
    
    
}
