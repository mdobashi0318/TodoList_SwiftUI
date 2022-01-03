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
    @Published var completionFlag: Bool = false
    
    /// Model側に格納する完了フラグの文字列
    @Published var completionFlagStr: CompletionFlag = .unfinished
        
    @Published var isError: Bool = false
    
    var errorMessage: String = ""
    
    private var cancellable: Set<AnyCancellable> = []
    
    init(model: ToDoModel) { 
        self.model = model
    }
    
    /// Modelから取得した完了フラグを画面側の完了フラグにセットする
    func setFlag(){
        self.completionFlag = model.completionFlag == CompletionFlag.completion.rawValue ? true : false
        swicthCompletionFlag()
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
    
    /// 画面側の完了フラグが変更されたらModelの完了フラグを更新する
    private func swicthCompletionFlag() {
        $completionFlag
            .print()
            .sink(receiveValue: { flag in
                self.completionFlagStr = flag ? .completion : .unfinished
                ToDoModel.updateCompletionFlag(updateTodo: self.model, flag: self.completionFlagStr)
            })
            .store(in: &cancellable)
    }

}
