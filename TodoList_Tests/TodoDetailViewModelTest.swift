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
        var model: ToDoModel = ToDoModel(id: "0", toDoName: "TEST", todoDate: "Date", toDo: "toDo", completionFlag: CompletionFlag.unfinished.rawValue)
        var viewModel = TodoDetailViewModel(model: model)
        viewModel.setFlag()
        XCTAssertFalse(viewModel.completionFlag, "falseが設定されていない")
        XCTAssert(viewModel.completionFlagStr == CompletionFlag.unfinished, "unfinishedの値が設定されていない")
        
        viewModel.completionFlag.toggle()
        XCTAssertTrue(viewModel.completionFlag, "trueが設定されていない")
        XCTAssert(viewModel.completionFlagStr == CompletionFlag.completion, "completionの値が設定されていない")
        
        
        /// completionFlagをtrueからfalseへ変更する
        model = ToDoModel(id: "0", toDoName: "TEST", todoDate: "Date", toDo: "toDo", completionFlag: CompletionFlag.completion.rawValue)
        viewModel = TodoDetailViewModel(model: model)
        viewModel.setFlag()
        XCTAssertTrue(viewModel.completionFlag, "trueが設定されていない")
        XCTAssert(viewModel.completionFlagStr == CompletionFlag.completion, "completionの値が設定されていない")
        
        viewModel.completionFlag.toggle()
        XCTAssertFalse(viewModel.completionFlag, "falseが設定されていない")
        XCTAssert(viewModel.completionFlagStr == CompletionFlag.unfinished, "unfinishedの値が設定されていない")
    }
    
    
    func test_findTodo() {
        let exp = expectation(description: "add")
        ToDoModel.addRealm(addValue: ToDoModel(toDoName: "TEST", todoDate: "2022/01/01 00:00", toDo: "toDo", completionFlag: CompletionFlag.unfinished.rawValue, createTime: ""), result:{ _ in exp.fulfill() })
        wait(for: [exp], timeout: 3.0)
        let viewModel = TodoDetailViewModel(model: ToDoModel(id: "1", toDoName: "", todoDate: "", toDo: "", completionFlag: ""))
        viewModel.findTodo()
        
        XCTAssert(viewModel.model?.toDoName == "TEST", "値が異なっている")
        XCTAssert(viewModel.model?.todoDate == "2022/01/01 00:00", "値が異なっている")
        XCTAssert(viewModel.model?.toDo == "toDo", "値が異なっている")
        XCTAssert(viewModel.model?.completionFlag == CompletionFlag.unfinished.rawValue, "値が異なっている")
        XCTAssertFalse(viewModel.completionFlag, "値が異なっている")
        
    }
}