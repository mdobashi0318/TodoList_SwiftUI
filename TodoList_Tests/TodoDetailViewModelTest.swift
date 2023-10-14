//
//  TodoDetailViewModelTest.swift
//  TodoList_SwiftUITests
//
//  Created by 土橋正晴 on 2021/07/22.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import Foundation
import XCTest
@testable import TodoList_SwiftUI

class TodoDetailViewModelTest: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ToDoModel.allDelete()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ToDoModel.allDelete()
    }
    
    
    func test_setFlag() {
        /// completionFlagをfalseからtrueへ変更する
        var model: ToDoModel = ToDoModel(id: "0", toDoName: "TEST", todoDate: "Date", toDo: "toDo", completionFlag: CompletionFlag.unfinished.rawValue, tag_id: "")
        var viewModel = TodoDetailViewModel(model: model)
        XCTAssertFalse(viewModel.completionFlag, "falseが設定されていない")
        XCTAssert(viewModel.completionFlagStr == CompletionFlag.unfinished, "unfinishedの値が設定されていない")
        
        viewModel.completionFlag.toggle()
        XCTAssertTrue(viewModel.completionFlag, "trueが設定されていない")
        XCTAssert(viewModel.completionFlagStr == CompletionFlag.completion, "completionの値が設定されていない")
        
        
        /// completionFlagをtrueからfalseへ変更する
        model = ToDoModel(id: "0", toDoName: "TEST", todoDate: "Date", toDo: "toDo", completionFlag: CompletionFlag.completion.rawValue, tag_id: "")
        viewModel = TodoDetailViewModel(model: model)
        XCTAssertTrue(viewModel.completionFlag, "trueが設定されていない")
        XCTAssert(viewModel.completionFlagStr == CompletionFlag.completion, "completionの値が設定されていない")
        
        viewModel.completionFlag.toggle()
        XCTAssertFalse(viewModel.completionFlag, "falseが設定されていない")
        XCTAssert(viewModel.completionFlagStr == CompletionFlag.unfinished, "unfinishedの値が設定されていない")
    }
    
    
    func test_findTodo() {
        try? ToDoModel.add(addValue: ToDoModel(toDoName: "TEST", todoDate: "2030/01/01 00:00", toDo: "toDo", completionFlag: CompletionFlag.unfinished.rawValue, createTime: "", tag_id: ""))
        let viewModel = TodoDetailViewModel(model: ToDoModel(id: "1", toDoName: "", todoDate: "", toDo: "", completionFlag: "", tag_id: ""))
        viewModel.findTodo()
        
        XCTAssert(viewModel.model.toDoName == "TEST", "値が異なっている")
        XCTAssert(viewModel.model.todoDate == "2030/01/01 00:00", "値が異なっている")
        XCTAssert(viewModel.model.toDo == "toDo", "値が異なっている")
        XCTAssert(viewModel.model.completionFlag == CompletionFlag.unfinished.rawValue, "値が異なっている")
        XCTAssertFalse(viewModel.completionFlag, "値が異なっている")
        
    }
    
    @MainActor
    func test_deleteTodo() async {
        try? ToDoModel.add(addValue: ToDoModel(toDoName: "TEST", todoDate: "2030/01/01 00:00", toDo: "toDo", completionFlag: CompletionFlag.unfinished.rawValue, createTime: "", tag_id: ""))
        let viewModel = TodoDetailViewModel(model: ToDoModel(id: "1", toDoName: "", todoDate: "", toDo: "", completionFlag: "", tag_id: ""))
        viewModel.findTodo()
        
        let todoViewModel = ToDoViewModel()
        await todoViewModel.fetchAllTodoModel()
        XCTAssert(todoViewModel.todoModel.count == 1)
        
        let dummy = try? viewModel.deleteTodo(delete: viewModel.model)
        XCTAssertNotNil(dummy, "ダミー用のモデルが入っていない")
        
        
        await todoViewModel.fetchAllTodoModel()
        XCTAssert(todoViewModel.todoModel.count == 0, "Todoが削除できていない")
    }
}
