//
//  InputViewModelTests.swift
//  InputViewModelTests
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import TodoList_SwiftUI

class InputViewModelTests: XCTestCase {
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ToDoModel.allDelete()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ToDoModel.allDelete()
        sleep(1)
    }
    
    
    
    func test_addTodo() {
        let inputViewModel = InputViewModel(model: ToDoModel(toDoName: "UnitTest", todoDate: "2030/01/01 00:00", toDo: "詳細", tag_id: ""))
        
        
        do {
            try inputViewModel.addTodo()
            let todoModel = ToDoModel.findTodo(todoId: "1", createTime: nil)
            XCTAssert(todoModel?.id == "1", "idが登録されていない")
            XCTAssert(todoModel?.toDoName == "UnitTest", "Todoのタイトルが登録されていない")
            XCTAssert(todoModel?.todoDate == "2030/01/01 00:00", "Todoの期限が登録されていない")
            XCTAssert(todoModel?.toDo == "詳細", "　Todoの詳細が登録されていない")
            XCTAssert(todoModel?.completionFlag == CompletionFlag.unfinished.rawValue, "完了フラグが未完が登録されていない")
            let createTime = todoModel?.createTime ?? ""
            XCTAssert(!createTime.isEmpty, "Todo作成時間が登録されていない")
        } catch {
            XCTAssertNil(error, "エラーが発生している\(error)")
        }
        
    }
    
    
    func test_updateTodo() {
        var inputViewModel = InputViewModel(model: ToDoModel(toDoName: "UnitTest", todoDate: "2030/01/01 00:00", toDo: "詳細", tag_id: ""))
        
        do {
            try inputViewModel.addTodo()
            let todoModel = ToDoModel.findTodo(todoId: "1", createTime: nil)
            XCTAssert(todoModel?.id == "1", "idが登録されていない")
            XCTAssert(todoModel?.toDoName == "UnitTest", "Todoのタイトルが登録されていない")
            XCTAssert(todoModel?.todoDate == "2030/01/01 00:00", "Todoの期限が登録されていない")
            XCTAssert(todoModel?.toDo == "詳細", "　Todoの詳細が登録されていない")
            XCTAssert(todoModel?.completionFlag == CompletionFlag.unfinished.rawValue, "完了フラグが未完が登録されていない")
            let createTime = todoModel?.createTime ?? ""
            XCTAssert(!createTime.isEmpty, "Todo作成時間が登録されていない")
        } catch {
            XCTAssertNil(error, "エラーが発生している\(error)")
        }
        
        inputViewModel = InputViewModel(model: ToDoModel(id: "1", toDoName: "EditUnitTest", todoDate: "2030/01/01 10:00", toDo: "詳細編集", createTime: nil, tag_id: ""))
        
        do {
            try inputViewModel.updateTodo()
            let todoModel = ToDoModel.findTodo(todoId: "1", createTime: nil)
            XCTAssert(todoModel?.id == "1", "idが登録されていない")
            XCTAssert(todoModel?.toDoName == "EditUnitTest", "Todoのタイトルが登録されていない")
            XCTAssert(todoModel?.todoDate == "2030/01/01 10:00", "　Todoの期限が登録されていない")
            XCTAssert(todoModel?.toDo == "詳細編集", "　Todoの詳細が登録されていない")
            XCTAssert(todoModel?.completionFlag == CompletionFlag.unfinished.rawValue, "完了フラグが未完が登録されていない")
            XCTAssert(!(todoModel?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
            
        } catch {
            XCTAssertNil(error, "エラーが発生している")
        }
        
    }
    
    
    
    func test_EditCompletionFlag() {
        var inputViewModel = InputViewModel(model: ToDoModel(toDoName: "UnitTest", todoDate: "2030/01/01 00:00", toDo: "詳細", tag_id: ""))
        
        do {
            try inputViewModel.addTodo()
            let todoModel = ToDoModel.findTodo(todoId: "1", createTime: nil)
            XCTAssert(todoModel?.id == "1", "idが登録されていない")
            XCTAssert(todoModel?.toDoName == "UnitTest", "Todoのタイトルが登録されていない")
            XCTAssert(todoModel?.todoDate == "2030/01/01 00:00", "Todoの期限が登録されていない")
            XCTAssert(todoModel?.toDo == "詳細", "　Todoの詳細が登録されていない")
            XCTAssert(todoModel?.completionFlag == CompletionFlag.unfinished.rawValue, "完了フラグが未完が登録されていない")
            let createTime = todoModel?.createTime ?? ""
            XCTAssert(!createTime.isEmpty, "Todo作成時間が登録されていない")
            
            UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
                XCTAssertTrue(notification[0].identifier == createTime, "Todoが登録されていない")
            }
        } catch {
            XCTAssertNil(error, "エラーが発生している\(error)")
        }
        inputViewModel = InputViewModel(model: ToDoModel(id: "1",
                                                         toDoName: "EditUnitTest",
                                                         todoDate: "2030/01/01 10:00",
                                                         toDo: "詳細編集",
                                                         completionFlag: CompletionFlag.completion.rawValue,
                                                         createTime: nil,
                                                         tag_id: "")
        )
        
        
        do {
            try inputViewModel.updateTodo()
            let todoModel = ToDoModel.findTodo(todoId: "1", createTime: nil)
            XCTAssert(todoModel?.id == "1", "idが登録されていない")
            XCTAssert(todoModel?.toDoName == "EditUnitTest", "Todoのタイトルが登録されていない")
            XCTAssert(todoModel?.todoDate == "2030/01/01 10:00", "　Todoの期限が登録されていない")
            XCTAssert(todoModel?.toDo == "詳細編集", "　Todoの詳細が登録されていない")
            XCTAssert(todoModel?.completionFlag == CompletionFlag.completion.rawValue, "完了フラグが完了が登録されていない")
            let createTime = todoModel?.createTime ?? ""
            XCTAssert(!createTime.isEmpty, "Todo作成時間が登録されていない")
            
            UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
                XCTAssertTrue(notification.isEmpty, "Todoが削除されていない")
            }
            
        } catch {
            XCTAssertNil(error, "エラーが発生している")
        }
    }
    
    
    func test_validateCheck() {
        let inputViewModel = InputViewModel()
        
        /// タイトル
        XCTAssert(inputViewModel.validateCheck() == R.string.message.validate(R.string.labels.title()), "バリデーションに引っかかっていない")
        inputViewModel.toDoName = "タイトル"
        XCTAssert(inputViewModel.validateCheck() != R.string.message.validate(R.string.labels.title()), "バリデーションに引っかかっている")
        
        
        /// 期限
        XCTAssert(inputViewModel.validateCheck() == R.string.message.validateDate(), "バリデーションに引っかかっていない")
        inputViewModel.completionFlag = true
        XCTAssert(inputViewModel.validateCheck() != R.string.message.validateDate(), "バリデーションに引っかかっている")
        
        inputViewModel.completionFlag = false
        inputViewModel.toDoDate = Date()
        XCTAssert(inputViewModel.validateCheck() == R.string.message.validateDate(), "バリデーションに引っかかっていない")
        
        inputViewModel.toDoDate = Format.dateFromString(string: "2030/01/01 00:00")!
        XCTAssert(inputViewModel.validateCheck() != R.string.message.validateDate(), "バリデーションに引っかかっている")
        
        inputViewModel.completionFlag = true
        XCTAssert(inputViewModel.validateCheck() != R.string.message.validateDate(), "バリデーションに引っかかっている")
        
                
        inputViewModel.toDo = "詳細"
        XCTAssert(inputViewModel.validateCheck() != R.string.message.validate(R.string.labels.details()), "バリデーションに引っかかっている")
        
        /// バリデーション突破
        XCTAssertNil(inputViewModel.validateCheck(), "バリデーションに引っかかっている")
    }
    
}
