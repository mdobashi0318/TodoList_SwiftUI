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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
