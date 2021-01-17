//
//  TodoList_SwiftUITests.swift
//  TodoList_SwiftUITests
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import TodoList_SwiftUI

class TodoList_SwiftUITests: XCTestCase {
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ToDoModel.allDelete()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ToDoModel.allDelete()
    }
    
    
    
    func test_AddViewModel() {
        
        let inputViewModel = InputViewModel(model: ToDoModel(toDoName: "UnitTest", todoDate: "2022/01/01 00:00", toDo: "詳細"))
        inputViewModel.addTodo().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                let todoModel = ToDoModel.findRealm(todoId: "1", createTime: nil)
                XCTAssert(todoModel?.id == "1", "idが登録されていない")
                XCTAssert(todoModel?.toDoName == "UnitTest", "Todoのタイトルが登録されていない")
                XCTAssert(todoModel?.todoDate == "2022/01/01 00:00", "Todoの期限が登録されていない")
                XCTAssert(todoModel?.toDo == "詳細", "　Todoの詳細が登録されていない")
                let createTime = todoModel?.createTime ?? ""
                XCTAssert(!createTime.isEmpty, "Todo作成時間が登録されていない")
            case .failure(let error):
                XCTAssertNil(error, "エラーが発生している\(error)")
            }
        }, receiveValue: {
            /// 何もしない
        }).cancel()
    }
    
    
    func test_EditViewModel() {
        var inputViewModel = InputViewModel(model: ToDoModel(toDoName: "UnitTest", todoDate: "2022/01/01 00:00", toDo: "詳細"))
        inputViewModel.addTodo()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    let todoModel = ToDoModel.findRealm(todoId: "1", createTime: nil)
                    XCTAssert(todoModel?.id == "1", "idが登録されていない")
                    XCTAssert(todoModel?.toDoName == "UnitTest", "Todoのタイトルが登録されていない")
                    XCTAssert(todoModel?.todoDate == "2022/01/01 00:00", "Todoの期限が登録されていない")
                    XCTAssert(todoModel?.toDo == "詳細", "　Todoの詳細が登録されていない")
                    let createTime = todoModel?.createTime ?? ""
                    XCTAssert(!createTime.isEmpty, "Todo作成時間が登録されていない")
                case .failure(let error):
                    XCTAssertNil(error, "エラーが発生している\(error)")
                }
            }, receiveValue: {
                /// 何もしない
            }).cancel()
        inputViewModel = InputViewModel(model: ToDoModel(id: "1", toDoName: "EditUnitTest", todoDate: "2022/01/01 10:00", toDo: "詳細編集", createTime: nil))
        
        
        inputViewModel.updateTodo()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    let todoModel = ToDoModel.findRealm(todoId: "1", createTime: nil)
                    XCTAssert(todoModel?.id == "1", "idが登録されていない")
                    XCTAssert(todoModel?.toDoName == "EditUnitTest", "Todoのタイトルが登録されていない")
                    XCTAssert(todoModel?.todoDate == "2022/01/01 10:00", "　Todoの期限が登録されていない")
                    XCTAssert(todoModel?.toDo == "詳細編集", "　Todoの詳細が登録されていない")
                    XCTAssert(!(todoModel?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
                case .failure(let error):
                    XCTAssertNil(error, "エラーが発生している")
                }
                
            }, receiveValue: {})
            .cancel()
    }
    
    
    
    func test_DeleteViewModel() {
        var todoModel: ToDoModel?
        
        let inputViewModel = InputViewModel(model: ToDoModel(toDoName: "UnitTest", todoDate: "2022/01/01 00:00", toDo: "詳細"))
        inputViewModel.addTodo()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    todoModel = ToDoModel.findRealm(todoId: "1", createTime: nil)
                    XCTAssert(todoModel?.id == "1", "idが登録されていない")
                    XCTAssert(todoModel?.toDoName == "UnitTest", "Todoのタイトルが登録されていない")
                    XCTAssert(todoModel?.todoDate == "2022/01/01 00:00", "Todoの期限が登録されていない")
                    XCTAssert(todoModel?.toDo == "詳細", "　Todoの詳細が登録されていない")
                    let createTime = todoModel?.createTime ?? ""
                    XCTAssert(!createTime.isEmpty, "Todo作成時間が登録されていない")
                case .failure(let error):
                    XCTAssertNil(error, "エラーが発生している\(error)")
                }
            }, receiveValue: {
                /// 何もしない
            }).cancel()
        
        ToDoViewModel().deleteTodo(delete: todoModel!)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertNil(ToDoModel.findRealm(todoId: "1", createTime: nil), "Todoの削除ができていない")
                case .failure(let error):
                    XCTAssertNil(error, "エラーが発生している\(error)")
                }
            }, receiveValue: { dummy in
                XCTAssertNotNil(dummy, "ダミー用のモデルが入っていない")
            })
            .cancel()
    }
    
}
