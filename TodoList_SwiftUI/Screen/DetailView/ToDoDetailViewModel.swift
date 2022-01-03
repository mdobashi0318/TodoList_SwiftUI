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
        
    @Published var completionFlag: Bool = false
    
    @Published var completionFlagStr: CompletionFlag = .unfinished
        
    @Published var isError: Bool = false
    
    var errorMessage: String = ""
    
    private var cancellable: Set<AnyCancellable> = []
    
    init(model: ToDoModel) { 
        self.model = model
    }
    
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
