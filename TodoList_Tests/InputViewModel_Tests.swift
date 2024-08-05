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
        ToDoModel.allDelete()
    }
    
    override func tearDown() {
        ToDoModel.allDelete()
    }
    
    func test_findTodo() {
        let todoDate = Format.dateFormat()
        try? ToDoModel.add(addValue: ToDoModel(toDoName: "toDoName",
                                               todoDate: Format.stringFromDate(date: todoDate),
                                               toDo: "toDo",
                                               tag_id: nil)
        )
        let primaryKey = ToDoModel.allFindTodo().first?.createTime
        
        
        var viewModel = ToDoInputView.ViewModel()
        XCTAssert(viewModel.toDoName.isEmpty, "viewModelのインスタンス生成時に引数渡していないので空になる")
        XCTAssert(viewModel.toDo.isEmpty, "viewModelのインスタンス生成時に引数渡していないので空になる")
        
        
        viewModel = ToDoInputView.ViewModel(createTime: primaryKey)
        XCTAssert(viewModel.toDoName == "toDoName")
        XCTAssert(viewModel.toDoDate == todoDate)
        XCTAssert(viewModel.toDo == "toDo")
    }
    
    
    func test_addTodo_validateCheck() {
        let viewModel = ToDoInputView.ViewModel()
        let name = "UnitTest"
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        let addDate = calendar.date(byAdding: .minute, value: 1, to: date)!
        viewModel.toDoName = ""
        viewModel.toDoDate = date
        var result = viewModel.addTodo()
        
        /// 名前と日付のバリデーションが引っかかること
        
        XCTAssert(viewModel.errorMessage == R.string.message.validate(R.string.labels.title()), "バリデーションに引っかかっていない")
        XCTAssertFalse(result, "追加の結果のBoolが違う")
        viewModel.toDoName = name
        result = viewModel.addTodo()
        
        XCTAssert(viewModel.errorMessage == R.string.message.validateDate(), "バリデーションに引っかかっていない")
        XCTAssertFalse(result, "追加の結果のBoolが違う")
        
        viewModel.toDoDate = addDate
        result = viewModel.addTodo()
        
        /// Todoに追加できること
        XCTAssert(viewModel.errorMessage.isEmpty, "エラーメッセージが空になっていない")
        XCTAssertTrue(result, "追加の結果のBoolが違う")
        
        
        let model = ToDoModel.allFindTodo().first!
        XCTAssert(model.toDoName == name)
        XCTAssert(model.todoDate == Format.stringFromDate(date: addDate))
        XCTAssert(model.toDo.isEmpty)
    }
    
    
    func test_updateTodo() {
        let name = "UnitTest"
        let detail = "Detail"
        let addTodoDate = Format.dateFormat()
        
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        let addDate = calendar.date(byAdding: .minute, value: 1, to: date)!
        
        try? ToDoModel.add(addValue: ToDoModel(toDoName: "toDoName",
                                               todoDate: Format.stringFromDate(date: addTodoDate),
                                               toDo: "toDo",
                                               tag_id: nil)
        )
        let primaryKey = ToDoModel.allFindTodo().first?.createTime
        
        
        let viewModel = ToDoInputView.ViewModel(createTime: primaryKey)
        XCTAssert(viewModel.toDoName == "toDoName")
        XCTAssert(viewModel.toDo == "toDo")
        
        
        viewModel.toDoName = name
        viewModel.toDoDate = addDate
        viewModel.toDo = detail
        let result = viewModel.updateTodo()
        XCTAssertTrue(result, "更新の結果のBoolが違う")
        
        
        let model = ToDoModel.allFindTodo().first!
        XCTAssert(model.toDoName == name)
        XCTAssert(model.todoDate == Format.stringFromDate(date: addDate))
        XCTAssert(model.toDo == detail)
    }
    
}
