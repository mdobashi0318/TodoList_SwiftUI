//
//  ToDoViewModel_Test.swift
//  TodoList_Tests
//
//  Created by 土橋正晴 on 2022/10/03.
//

import XCTest
@testable import TodoList_SwiftUI

final class ToDoViewModel_Test: XCTestCase {
    
    private var viewModel: ToDoViewModel!
    
    override func setUp() {
        viewModel = ToDoViewModel()
        ToDoModel.allDelete()
        
        try? ToDoModel.add(addValue: ToDoModel(toDoName: "TEST1", todoDate: "2030/01/01 00:00", toDo: "toDo1", completionFlag: CompletionFlag.unfinished.rawValue, createTime: ""))
        
        try? ToDoModel.add(addValue: ToDoModel(toDoName: "TEST2", todoDate: "2000/01/01 00:00", toDo: "toDo2", completionFlag: CompletionFlag.unfinished.rawValue, createTime: ""))
        
        try? ToDoModel.add(addValue: ToDoModel(toDoName: "TEST3", todoDate: "2000/01/01 00:00", toDo: "toDo3", completionFlag: CompletionFlag.unfinished.rawValue, createTime: ""))
        
    }
    
    override func tearDown() {
        sleep(1)
        ToDoModel.allDelete()
    }
    
    @MainActor
    func test_fetchAllTodoModel() async throws {
            await viewModel.fetchAllTodoModel()
            XCTAssert(viewModel.todoModel.count == 3, "全件取得できていない")
            
            viewModel.segmentIndex = .active
            await viewModel.fetchAllTodoModel()
            XCTAssert(viewModel.todoModel.count == 1 , "未完了のみの取得できていない")
            
            viewModel.segmentIndex = .expired
            await viewModel.fetchAllTodoModel()
            XCTAssert(viewModel.todoModel.count == 2 , "期限切れのみの取得できていない")
            
            viewModel.segmentIndex = .complete
            await viewModel.fetchAllTodoModel()
            XCTAssert(viewModel.todoModel.count == 0 , "完了のみの取得できていない")
            
            viewModel.segmentIndex = .all
            await viewModel.fetchAllTodoModel()
            ToDoModel.updateCompletionFlag(updateTodo: viewModel.todoModel[0], flag: .completion)
            viewModel.segmentIndex = .complete
            await viewModel.fetchAllTodoModel()
            XCTAssert(viewModel.todoModel.count == 1 , "完了のみの取得できていない")
            
            
            viewModel.segmentIndex = .expired
            await viewModel.fetchAllTodoModel()
            XCTAssert(viewModel.todoModel.count == 1 , "期限切れのみの取得できていない")
    
    }
    
    
    
    @MainActor
    func test_allDeleteTodo() async {
        await viewModel.fetchAllTodoModel()
        XCTAssert(viewModel.todoModel.count == 3, "Todoの取得失敗")
        
        viewModel.allDeleteTodo()
        await viewModel.fetchAllTodoModel()
        XCTAssert(viewModel.todoModel.count == 0, "Todoが全件削除できていない")
        
    }
}
