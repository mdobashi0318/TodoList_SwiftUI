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
}



class ToDoModel: Object, ObservableObject {
    
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
    class func addRealm(addValue:TableValue) {
        
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
    class func updateRealm(todoId: Int, updateValue: TableValue) {
        guard let realm = initRealm() else { return }
        let toDoModel: ToDoModel = (realm.objects(ToDoModel.self).filter("id == '\(String(describing: todoId))'").first!)
        
        do {
            try realm.write() {
                toDoModel.toDoName = updateValue.title
                toDoModel.todoDate = updateValue.date
                toDoModel.toDo = updateValue.detail
            }
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
    ///   - completion: 削除完了後の動作
    class func deleteRealm(_ vc: UIViewController, todoId: Int, createTime: String?, completion: () ->Void) {
        guard let realm = initRealm() else { return }
        let toDoModel: ToDoModel = (realm.objects(ToDoModel.self).filter("id == '\(String(describing: todoId))'").first!)
        
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: [toDoModel.toDoName])
        
        do {
            try realm.write() {
                realm.delete(toDoModel)
            }
        }
            
        catch {
            print("エラーが発生しました")
        }
        
        
        completion()
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

