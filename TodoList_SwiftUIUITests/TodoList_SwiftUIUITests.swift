//
//  TodoList_SwiftUIUITests.swift
//  TodoList_SwiftUIUITests
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest

@available(iOS 14.0, *)
class TodoList_SwiftUIUITests: XCTestCase {
    
    
    
    let addTitle = "TodoAddTestTitle"
    let addDetail = "TodoAddTestDetail"
    
    
    let updateTitle = "TodoUpdateTestTitle"
    let updateDetail = "TodoUpdateTestDetail"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        let app = XCUIApplication()
        app.launch()
        app.buttons["allDeleteButton"].tap()
        sleep(1)
        app.alerts.buttons["削除"].tap()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    
    func test_toDoAddTest() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.buttons["addButton"].exists, "Todo追加するためのモーダルを開くaddButtonがない")
        XCTAssertTrue(app.buttons["allDeleteButton"].exists, "全件削除用のボタンがない")
        
        app.buttons["addButton"].tap()
        sleep(1)
        
        app.textFields["titleTextField"].tap()
        app.typeText(addTitle)
        app.buttons["Return"].tap()
        
        sleep(1)
        app.datePickers["todoDatePicker"].tap()
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText("11:59")
        app.textFields["titleTextField"].tap()
        
        sleep(1)
        app.textFields["detailTextField"].tap()
        app.typeText(addDetail)
        
        app.buttons["todoAddButton"].tap()
        sleep(1)
        
        XCTAssertTrue(app.buttons.element(boundBy: 2).label.contains(addTitle), "登録されたタイトルが表示されていない")
        
    }
    
    
    func test_validateAlert() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["addButton"].tap()
        sleep(1)
        
        
        
        app.buttons["todoAddButton"].tap()
        sleep(1)
        
        XCTAssertTrue(app.alerts["タイトルが入力されていません"].exists, "未入力項目あり時のアラートが表示されない")
        app.alerts.buttons["閉じる"].tap()
        
        app.textFields["titleTextField"].tap()
        app.typeText(addTitle)
        
        app.buttons["todoAddButton"].tap()
        sleep(1)
        
        XCTAssertTrue(app.alerts["入力されている期限が無効です"].exists, "未入力項目あり時のアラートが表示されない")
        app.alerts.buttons["閉じる"].tap()
        
        app.datePickers["todoDatePicker"].tap()
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText("11:59")
        app.textFields["titleTextField"].tap()
        sleep(1)
        
        app.buttons["todoAddButton"].tap()
        sleep(1)
        
        XCTAssertTrue(app.alerts["詳細が入力されていません"].exists, "未入力項目あり時のアラートが表示されない")
        app.alerts.buttons["閉じる"].tap()
        sleep(1)
        
        app.textFields["detailTextField"].tap()
        app.typeText(addTitle)
        
        app.buttons["todoAddButton"].tap()
        sleep(1)
        
        XCTAssertTrue(!app.alerts["詳細が入力されていません"].exists, "未入力項目あり時のアラートが表示されない")
        
    }
    
    
    func test_toDoUpdateTest() throws {
        let app = XCUIApplication()
        addTodo()
        app.buttons.element(boundBy: 2).tap()
        sleep(1)
        XCTAssertTrue(app.navigationBars.staticTexts.element(boundBy: 0).label == addTitle, "タイトルが表示されていない")
        XCTAssertTrue(app.staticTexts["dateLabel"].label != "", "期限が表示されていないされていない")
        XCTAssertTrue(app.staticTexts["todoDetaillabel"].label == addDetail, "詳細が表示されていない")
        
        
        app.buttons["todoActionButton"].tap()
        sleep(1)
        app.sheets.buttons["編集"].tap()
        
        sleep(1)
        app.textFields["titleTextField"].tap()
        sleep(1)
        for _ in 0 ..< addTitle.count {
            app.keys["delete"].tap()
        }
        app.typeText(updateTitle)
        app.buttons["Return"].tap()
        
        sleep(1)
        app.textFields["detailTextField"].press(forDuration: 3)
        sleep(1)
        for _ in 0 ..< addDetail.count {
            app.keys["delete"].tap()
        }
        app.typeText(updateDetail)
        
        app.buttons["todoAddButton"].tap()
        sleep(1)
        
        
        XCTAssertTrue(app.navigationBars.staticTexts.element(boundBy: 0).label == updateTitle, "タイトルが更新されていない")
        XCTAssertTrue(app.staticTexts["dateLabel"].label != "", "期限が表示されていないされていない")
        XCTAssertTrue(app.staticTexts["todoDetaillabel"].label == updateDetail, "詳細が更新されていない")
        
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        XCTAssertTrue(app.buttons.element(boundBy: 2).label.contains(updateTitle), "タイトルが更新されていない")
    }
    
    
    
    
    func test_toDoDeleteTest() throws {
        let app = XCUIApplication()
        
        addTodo()
        app.buttons.element(boundBy: 2).tap()
        sleep(1)
        XCTAssertTrue(app.navigationBars.staticTexts.element(boundBy: 0).label == addTitle, "タイトルが表示されていない")
        XCTAssertTrue(app.staticTexts["dateLabel"].label != "", "期限が表示されていないされていない")
        XCTAssertTrue(app.staticTexts["todoDetaillabel"].label == addDetail, "詳細が表示されていない")
        sleep(1)
        
        app.buttons["todoActionButton"].tap()
        sleep(1)
        app.sheets.buttons["削除"].tap()
        sleep(1)
        app.alerts.buttons["削除"].tap()
        sleep(1)
        
        XCTAssertTrue(app.staticTexts["ToDoが登録されていません"].exists, "Todoが削除されていない")
        
    }
    
    
    func test_ToDoInputViewUICheck() {
        let app = XCUIApplication()
        
        app.buttons["addButton"].tap()

        XCTAssertTrue(app.tables["ToDoInputView"].exists, "Todo入力画面が開いていない")
        XCTAssertTrue(app.buttons["todoAddButton"].exists, "Todo追加ボタンがない")
        XCTAssertTrue(app.buttons["cancelButton"].exists, "キャンセルボタンがない")
        
        XCTAssertTrue(app.staticTexts["titlelabel"].exists, "タイトルラベルがない")
        XCTAssertTrue(app.textFields["titleTextField"].exists, "タイトルテキストフィールドがない")
        
        XCTAssertTrue(app.staticTexts["期限"].exists, "期限ラベルがない")
        XCTAssertTrue(app.datePickers["todoDatePicker"].exists, "期限登録するdatePickerがない")
        
        XCTAssertTrue(app.staticTexts["detailLabel"].exists, "詳細ラベルがない")
        XCTAssertTrue(app.textFields["detailTextField"].exists, "詳細テキストフィールドがない")
        
        app.buttons["cancelButton"].tap()
        sleep(1)
        XCTAssertFalse(app.scrollViews["ToDoInputView"].exists, "Todo入力画面が閉じれられていない")
        
    }
    
    
    /// Todoを追加する
    func addTodo() {
        let app = XCUIApplication()
        
        app.buttons["addButton"].tap()
        sleep(1)
        
        app.textFields["titleTextField"].tap()
        app.typeText(addTitle)
        app.buttons["Return"].tap()
        
        sleep(1)
        app.datePickers["todoDatePicker"].tap()
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText("11:59")
        app.textFields["titleTextField"].tap()
        
        sleep(1)
        app.textFields["detailTextField"].tap()
        sleep(1)
        app.typeText(addDetail)
        
        app.buttons["todoAddButton"].tap()
        sleep(1)
        
    }

}
