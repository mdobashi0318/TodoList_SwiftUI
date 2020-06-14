//
//  NotificationManager.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/06/14.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    /// 通知を全件削除する
    let allRemoveNotification = {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("ToDoの通知を全件削除しました")
    }
    
    
    /// 指定した通知を削除する
    let removeNotification = { (identifiers: [String]) -> Void in
        UNUserNotificationCenter
        .current()
        .removePendingNotificationRequests(withIdentifiers: identifiers)
        print("ToDoの通知を\(identifiers.count)件削除しました")
    }
    
    

    /// 通知を設定する
    /// - Parameters:
    ///   - toDoModel: ToDoModels
    ///   - isRequestResponse: 通知の登録に成功したかを返す
    func addNotification(toDoModel: ToDoModel, isRequestResponse: @escaping(Bool) -> ()) {
        
        let content:UNMutableNotificationContent = UNMutableNotificationContent()
        content.title = toDoModel.toDoName
        content.body = toDoModel.toDo
        content.sound = UNNotificationSound.default
        
        //通知する日付を設定
        guard let date:Date = Format().dateFromString(string: toDoModel.todoDate) else {
            print("期限の登録に失敗しました")
            isRequestResponse(false)
            
            return
        }
        
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute] , from: date)
        let trigger:UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request:UNNotificationRequest = UNNotificationRequest.init(identifier: toDoModel.createTime!, content: content, trigger: trigger)
        let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
        
        center.add(request) { (error) in
            print("request: \(request)")
            
            if error != nil {
                print("通知の登録に失敗しました: \(error!)")
                isRequestResponse(false)
                
            } else {
                print("通知の登録をしました")
                isRequestResponse(true)
                
            }
        }
    }
    
}

