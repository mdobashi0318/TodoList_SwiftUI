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
    
    
    func test_AddModel() {
        
        ToDoModel.addRealm(addValue: ToDoModel(id: "0", toDoName: "UnitTest", todoDate: "2020/01/01 00:00", toDo: "詳細", createTime: nil)) { result in
            XCTAssertNil(result, "エラーが発生している")
        }
        
        let todoModel = ToDoModel.findRealm(todoId: "0", createTime: nil)
        
        XCTAssert(todoModel?.id == "0", "idが登録されていない")
        XCTAssert(todoModel?.toDoName == "UnitTest", "Todoのタイトルが登録されていない")
        XCTAssert(todoModel?.todoDate == "2020/01/01 00:00", "Todoの期限が登録されていない")
        XCTAssert(todoModel?.toDo == "詳細", "　Todoの詳細が登録されていない")
        XCTAssert(!(todoModel?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
    }
    
    
    
    func test_EditModel() {
        ToDoModel.addRealm(addValue: ToDoModel(id: "0", toDoName: "UnitTest", todoDate: "2020/01/01 00:00", toDo: "詳細", createTime: nil)) { result in
            XCTAssertNil(result, "エラーが発生している")
        }
        
        
        ToDoModel.updateRealm(updateTodo: ToDoModel(id: "0", toDoName: "EditUnitTest", todoDate: "2020/01/01 10:00", toDo: "詳細編集", createTime: nil)) { result in
            XCTAssertNil(result, "エラーが発生している")
        }
        
        
        let todoModel = ToDoModel.findRealm(todoId: "0", createTime: nil)
        XCTAssert(todoModel?.id == "0", "idが登録されていない")
        XCTAssert(todoModel?.toDoName == "EditUnitTest", "Todoのタイトルが登録されていない")
        XCTAssert(todoModel?.todoDate == "2020/01/01 10:00", "　Todoの期限が登録されていない")
        XCTAssert(todoModel?.toDo == "詳細編集", "　Todoの詳細が登録されていない")
        XCTAssert(!(todoModel?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
    }
    
    
}
