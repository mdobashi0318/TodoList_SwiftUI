//
//  TodoWidgetAppIntent.swift
//  TodoWidgetExtension
//
//  Created by 土橋正晴 on 2023/09/30.
//

import Foundation
import AppIntents


@available(iOS 17.0, *)
struct TodoWidgetAppIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Todo"
    
    @Parameter(title: "createTime")
    var createTime: String
    
    init() {
        createTime = ""
    }
    
    
    init(_ createTime: String) {
        self.createTime = createTime
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        guard let todo = ToDoModel.findTodo(todoId: "", createTime: createTime) else { return .result() }
        ToDoModel.updateCompletionFlag(
            updateTodo: todo,
            flag: CompletionFlag.completion
        )
        
        return .result()
    }
}
