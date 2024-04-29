//
//  NotificationManagerTests.swift
//  TodoList_SwiftUITests
//
//  Created by 土橋正晴 on 2020/06/14.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import TodoList_SwiftUI

class NotificationManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        NotificationManager().allRemoveNotification()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_addNotification() {
        
        let createTime1 = Format.stringFromDate(date: Date(), addSec: .ms)
        NotificationManager().addNotification(toDoModel: ToDoModel(toDoName: "TEST", todoDate: Format.stringFromDate(date: Date(timeIntervalSinceNow: 60 * 60 * 48)), toDo: "TESTTodo", createTime: createTime1, tag_id: "")) { result in
            XCTAssertTrue(result, "Todoの登録に失敗している")
        }
        
        
        NotificationManager().addNotification(toDoModel: ToDoModel(toDoName: "TEST", todoDate: "TESTDate", toDo: "TESTTodo", createTime: Format.stringFromDate(date: Date(), addSec: .ms), tag_id: "")) { result in
            XCTAssertFalse(result, "Todoの登録に成功している")
        }
        
        sleep(1)
        UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
            XCTAssertTrue(notification.count == 1, "Todoが作成した以上に登録されている")
            XCTAssertTrue(notification[0].identifier == createTime1, "Todoが登録されていない")
            
        }
        
    }
    
    
        
    
    func test_deleteNotification() {
        
        let createTime1 = Format.stringFromDate(date: Date(), addSec: .ms)
        let todoDate1 = Format.stringFromDate(date: Date(timeIntervalSinceNow: 60 * 60 * 48))
        let todoModel1 = ToDoModel(toDoName: "TEST", todoDate: todoDate1, toDo: "TESTTodo", createTime: createTime1, tag_id: "")
        NotificationManager().addNotification(toDoModel: todoModel1) { _ in
        }
        sleep(1)
        
        let createTime2 = Format.stringFromDate(date: Date(), addSec: .ms)
        let todoDate2 = Format.stringFromDate(date: Date(timeIntervalSinceNow: 60 * 60 * 48))
        let todoModel2 = ToDoModel(toDoName: "TEST", todoDate: todoDate2, toDo: "TESTTodo", createTime: createTime2, tag_id: "")
        NotificationManager().addNotification(toDoModel: todoModel2) { _ in
        }
        
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
            XCTAssertTrue(notification.count == 2, "Todoが作成した以上に登録されている")
            XCTAssertTrue(notification[0].identifier == todoModel1.createTime!, "Todoが登録されていない")
            XCTAssertTrue(notification[1].identifier == todoModel2.createTime!, "Todoが登録されていない")
        }
        
        /// 削除
        NotificationManager().removeNotification([todoModel1.createTime!])
        sleep(1)
        /// 削除されたことの確認
        UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
            XCTAssertTrue(notification.count == 1, "Todoが作成した以上に登録されている")
            XCTAssertTrue(notification[0].identifier == todoModel2.createTime!, "Todoが登録されていない")
        }
        
    }

    
    
    func test_allDeleteNotification() throws {
        
        let createTime1 = Format.stringFromDate(date: Date(), addSec: .ms)
        let todoDate1 = Format.stringFromDate(date: Date(timeIntervalSinceNow: 60 * 60 * 48))
        let todoModel1 = ToDoModel(toDoName: "TEST", todoDate: todoDate1, toDo: "TESTTodo", createTime: createTime1, tag_id: "")
        NotificationManager().addNotification(toDoModel: todoModel1) { _ in
        }
        sleep(1)
        
        let createTime2 = Format.stringFromDate(date: Date(), addSec: .ms)
        let todoDate2 = Format.stringFromDate(date: Date(timeIntervalSinceNow: 60 * 60 * 48))
        let todoModel2 = ToDoModel(toDoName: "TEST", todoDate: todoDate2, toDo: "TESTTodo", createTime: createTime2, tag_id: "")
        NotificationManager().addNotification(toDoModel: todoModel2) { _ in
        }
        
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
            XCTAssertTrue(notification.count == 2, "Todoが2件が登録されていない")
            XCTAssertTrue(notification[0].identifier == todoModel1.createTime!, "Todoが登録されていない")
            XCTAssertTrue(notification[1].identifier == todoModel2.createTime!, "Todoが登録されていない")
        }
        
        /// 削除
        NotificationManager().allRemoveNotification()
        sleep(1)
        /// 削除されたことの確認
        UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
            XCTAssertTrue(notification.count == 0, "Todoが削除されていない")
        }
        
    }


}
