//
//  ToDoModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift
import Combine



class ToDoViewModel: ObservableObject {
    
    @Published var todoModel: Results<ToDoModel> = ToDoModel.allFindRealm()!
    
    /// Realmのモデルを参照しない時はTestデータの配列を使う
//    @Published var todoModel: [ToDoModel] = todomodel
    
    
    
    /// 更新するTodoを返す
    class func todoUpdate(_ model: ToDoModel) -> ToDoModel {
        let todo = ToDoModel()
        todo.id = model.id
        todo.toDoName = model.toDoName
        todo.todoDate = model.todoDate
        todo.toDo = model.toDo
        
        return todo
    }
    

    
}



class ToDoModel: Object {
    
    @objc dynamic var id:String = ""
    
    
    /// Todoの期限
    @objc dynamic var todoDate:String = ""
    
    /// Todoのタイトル
    @objc dynamic var toDoName:String = ""
    
    /// Todoの詳細
    @objc dynamic var toDo:String = ""
    
    /// Todoの作成日時
    @objc dynamic var createTime:String?
    
    
    // idをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "createTime"
    }
    
    
    
    
    
    /// Realmのインスタンス化
    class func initRealm() -> Realm? {
        
        let realm: Realm
        do {
            realm = try Realm()
            
            return realm
        }
        catch {
            print("エラーが発生しました")
        }
        return nil
    }
    
    
    /// ToDoを追加する
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - addValue: 登録するTodoの値
    class func addRealm(addValue:TableValue, date: Date) {
        
        guard let realm = initRealm() else { return }
        let toDoModel: ToDoModel = ToDoModel()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ja_JP")
        let s_Date:String = formatter.string(from: Date())
        
        toDoModel.id = addValue.id
        toDoModel.toDoName = addValue.title
        toDoModel.todoDate = addValue.date
        toDoModel.toDo = addValue.detail
        toDoModel.createTime = s_Date
        
        do {
            try realm.write() {
                realm.add(toDoModel)
            }
            
            ToDoModel.addNotification(todoModel: toDoModel, date: date)
        }
        catch {
            print("エラーが発生しました")
        }
    
    }
    
    
    /// ToDoの更新
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - todoId: TodoId
    ///   - updateValue: 更新する値
    class func updateRealm(todoId: Int, updateValue: TableValue, date: Date) {
        guard let realm = initRealm() else { return }
        let toDoModel: ToDoModel = (realm.objects(ToDoModel.self).filter("id == '\(String(describing: todoId))'").first!)
        
        do {
            try realm.write() {
                toDoModel.toDoName = updateValue.title
                toDoModel.todoDate = updateValue.date
                toDoModel.toDo = updateValue.detail
            }
            ToDoModel.addNotification(todoModel: toDoModel, date: date)
        }
        catch {
            print("エラーが発生しました")
        }
        
    }
    
    
    /// １件取得
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - todoId: TodoId
    ///   - createTime: Todoの作成時間
    /// - Returns: 取得したTodoの最初の1件を返す
    class func findRealm(todoId: Int, createTime: String?) -> ToDoModel? {
        guard let realm = initRealm() else { return nil }
        
        if let _createTime = createTime {
            return (realm.objects(ToDoModel.self).filter("createTime == '\(String(describing: _createTime))'").first)
        } else {
            return(realm.objects(ToDoModel.self).filter("id == '\(String(describing: todoId))'").first!)
        }
        
        
    }
    
    
    /// 全件取得
    /// - Parameter vc: 呼び出し元のViewController
    /// - Returns: 取得したTodoを全件返す
    class func allFindRealm() -> Results<ToDoModel>? {
        guard let realm = initRealm() else { return nil }
        
        let resultModel = realm.objects(ToDoModel.self)
        var quizModel = [ToDoModel]()
        for model in resultModel {
            quizModel.append(model)
        }
        return realm.objects(ToDoModel.self)
    }
    
    
    /// ToDoの削除
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - todoId: TodoId
    ///   - createTime: Todoの作成時間
    ///   - returnValue: 空のTodoを返す
    ///   - completion: 削除完了後の動作
    class func deleteRealm(todoId: String, createTime: String?,returnValue: (ToDoModel) -> Void , completion: () ->Void) {
        guard let realm = initRealm() else { return }
        let toDoModel: ToDoModel = (realm.objects(ToDoModel.self).filter("id == '\(todoId)'").first!)
        
        let todo = ToDoModel()
        todo.toDoName = ""
        todo.toDo = ""
        todo.todoDate = ""
        returnValue(todo)
        
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: [toDoModel.toDoName])
        
        do {
            try realm.write() {
                realm.delete(toDoModel)
            }
            completion()
        }
            
        catch {
            print("エラーが発生しました")
        }
        
        
        
    }
    
    
    /// 全件削除
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - completion: 削除完了後の動作
    class func allDeleteRealm(_ vc: UIViewController, completion:@escaping () ->Void) {
        guard let realm = initRealm() else { return }
        
        
            try! realm.write {
                realm.deleteAll()
            }
            completion()

        
        
    }
    
    
    class func allDelete() {

        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    /// 通知を設定する
    class func addNotification(todoModel: ToDoModel, date: Date) {
        
        let content:UNMutableNotificationContent = UNMutableNotificationContent()
        
        content.title = todoModel.toDoName
        
        content.body = todoModel.toDo
        
        content.sound = UNNotificationSound.default
        
        
        //通知する日付を設定
        let date:Date = ToDoModel.dateFromString(string: todoModel.todoDate)
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute] , from: date)
        let trigger:UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request:UNNotificationRequest = UNNotificationRequest.init(identifier: content.title, content: content, trigger: trigger)
        
        let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            
        }
        
    }
    
    
    
    class func dateFromString(string: String) -> Date {
           let formatter: DateFormatter = DateFormatter()
           formatter.calendar = Calendar(identifier: .gregorian)
           formatter.dateFormat = "yyyy/MM/dd HH:mm"
           return formatter.date(from: string)!
       }
    
    
    
    /// Dateのフォーマットを設定
    class func stringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.locale = Locale(identifier: "ja_JP")
        let s_Date:String = formatter.string(from: date)
        
        return s_Date
    }
    
    
}

import Foundation

struct TableValue {
    let id: String
    let title:String
    let date:String
    let detail:String
    let createTime:String?
    
    init(id:String, title:String, todoDate:String, detail: String, createTime: String? = nil) {
        self.id = id
        self.title = title
        self.date = todoDate
        self.detail = detail
        self.createTime = createTime
    }
}





/// テスト用の配列
let todomodel:[ToDoModel] = {
    
    var todomodel = [ToDoModel]()
    
    let todo1 = ToDoModel()
    todo1.toDoName = "TODOName1"
    todo1.todoDate = "2020/01/01 00:00:01"
    todo1.toDo = "TODO詳細1"
    todo1.createTime = "2020/01/01 00:00:01"
    
    let todo2 = ToDoModel()
    todo2.toDoName = "TODOName2"
    todo2.todoDate = "2020/01/01 00:00:02"
    todo2.toDo = "TODO詳細2"
    todo2.createTime = "2020/01/01 00:00:02"
    
    let todo3 = ToDoModel()
    todo3.toDoName = "TODOName3"
    todo3.todoDate = "2020/01/01 00:00:03"
    todo3.toDo = "TODO詳細3"
    todo3.createTime = "2020/01/01 00:00:03"
    
    
    let todo4 = ToDoModel()
    todo4.toDoName = "TODOName4"
    todo4.todoDate = "2020/01/01 00:00:04"
    todo4.toDo = "TODO詳細4"
    todo4.createTime = "2020/01/01 00:00:04"
    
    todomodel.append(todo1)
    todomodel.append(todo2)
    todomodel.append(todo3)
    todomodel.append(todo4)
    
    return todomodel
}()
