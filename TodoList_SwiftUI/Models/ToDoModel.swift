//
//  ToDoModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift
import WidgetKit

// MARK: - ToDoModel

final class ToDoModel: Object {
    
    private static let initRealm: Realm? = {
        var configuration: Realm.Configuration
        let realm: Realm
        do {
            configuration = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.TodoList-SwiftUI")
            configuration.fileURL = url!.appendingPathComponent("db.realm")
            realm = try Realm(configuration: configuration)
            return realm
        }
        catch {
            print("エラーが発生しました")
        }
        return nil
    }()
    
    
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
    
    
    
    // MARK: init
    
    convenience init(id: String, toDoName: String, todoDate: String, toDo: String, createTime: String?) {
        self.init()
        
        self.id = id
        self.toDoName = toDoName
        self.todoDate = todoDate
        self.toDo = toDo
        self.createTime = createTime
    }
    
     // MARK: Todo取得
    
    /// 全件取得
    /// - Returns: 取得したTodoを全件返す
    static func allFindRealm() -> [ToDoModel]? {
        guard let realm = initRealm else { return nil }
        var model = [ToDoModel]()
        
        let realmModel = realm.objects(ToDoModel.self)
        
        realmModel.forEach { todo in
            model.append(todo)
        }
        model.sort {
            $0.todoDate < $1.todoDate
        }
        
        return model
    }
    
    
    /// １件取得
    /// - Parameters:
    ///   - todoId: TodoId
    ///   - createTime: Todoの作成時間
    /// - Returns: 取得したTodoの最初の1件を返す
    static func findRealm(todoId: String, createTime: String?) -> ToDoModel? {
        guard let realm = initRealm else { return nil }
        
        if let _createTime = createTime {
            return (realm.objects(ToDoModel.self).filter("createTime == '\(String(describing: _createTime))'").first)
        } else {
            return (realm.objects(ToDoModel.self).filter("id == '\(String(describing: todoId))'").first!)
        }
        
    }
    
  
    // MARK: Todo追加
    
    /// ToDoを追加する
    /// - Parameters:
    ///   - addValue: 登録するTodoの値
    ///   - result: Todoの登録時のエラー
    /// - Returns: エラーがなければnil、あればエラーを返す
    static func addRealm(addValue:ToDoModel, result: (Error?) -> () ) {
        
        guard let realm = initRealm else { return }
        
        let toDoModel: ToDoModel = ToDoModel()
        toDoModel.id = addValue.id
        toDoModel.toDoName = addValue.toDoName
        toDoModel.todoDate = addValue.todoDate
        toDoModel.toDo = addValue.toDo
        toDoModel.createTime = Format().stringFromDate(date: Date(), addSec: true)
        
        do {
            try realm.write() {
                realm.add(toDoModel)
            }
            
            NotificationManager().addNotification(toDoModel: toDoModel) { _ in
                /// 何もしない
            }
            
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
            
            result(nil)
        }
        catch {
            result(error)
        }
    
    }
    
    
    // MARK: Todo更新
    
    /// ToDoの更新
    /// - Parameters:
    ///   - updateTodo: 更新する値
    ///   - result: Todoの更新時のエラー
    /// - Returns: エラーがなければnil、あればエラーを返す
    static func updateRealm(updateTodo: ToDoModel, result: (String?) -> () ) {
        guard let realm = initRealm else { return }
        let toDoModel: ToDoModel = ToDoModel.findRealm(todoId: updateTodo.id, createTime: updateTodo.createTime)!
        
        do {
            try realm.write() {
                toDoModel.toDoName = updateTodo.toDoName
                toDoModel.todoDate = updateTodo.todoDate
                toDoModel.toDo = updateTodo.toDo
            }
            NotificationManager().addNotification(toDoModel: toDoModel) { _ in
                /// 何もしない
            }
            
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
            
            result(nil)
        }
        catch {
            result("Todoの更新に失敗しました")
        }
        
    }
    
    
    // MARK: Todo削除
    
    /// ToDoの削除
    /// - Parameters:
    ///   - todoId: TodoId
    ///   - createTime: Todoの作成時間
    static func deleteRealm(todoId: String, createTime: String, result: (String?) -> () ) {
        guard let realm = initRealm else { return }
        let toDoModel: ToDoModel = ToDoModel.findRealm(todoId: todoId, createTime: createTime)!
        NotificationManager().removeNotification([createTime])
        
        do {
            try realm.write() {
                realm.delete(toDoModel)
            }
            
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
            
            result(nil)
        }
            
        catch {
            result("ToDoの削除に失敗しました")
        }
          
    }
    
    
    /// 全件削除
    static func allDelete() {
        guard let realm = initRealm else { return }
        
        try! realm.write {
            realm.deleteAll()
        }
        
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        NotificationManager().allRemoveNotification()
        
    }
    
    
    /// FileManagerに移行前のRealm
    private func oldRealm() -> Realm? {
        let oldRealm: Realm
        do {
            oldRealm = try Realm()
            return oldRealm
        }
        catch {
            print("エラーが発生しました")
        }
        return nil
    }
    
    
    /// Realmの保存場所にFileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.TodoList-SwiftUI")を設定したので、設定前の値をFileManagerに移行してから以前の値を削除
    func change_TodoModel_Ver() {
        print("v1.3.0以前に作成したTodoの移行と削除を開始")
        let oldRealm = self.oldRealm()
        let oldTodoModel = oldRealm?.objects(ToDoModel.self)
        var comNum: Int = 0
        
        /// 前バージョンのローカル通知を削除
        NotificationManager().allRemoveNotification()
        
        oldTodoModel?.forEach { todo in
            ToDoModel.addRealm(addValue: todo) { resul in
                if resul == nil {
                    print("追加に成功: \(todo)")
                    comNum += 1
                }
            }
        }
        print("移行に成功した件数: \(String(describing: comNum))/\(String(describing: oldTodoModel?.count ?? 0))")
        
        do {
            try oldRealm?.write {
                /// 前バージョンのModelを削除
                oldRealm?.deleteAll()
                UserDefaults.standard.setInt(key: .RealmFileVer, value: 1)
                print("v1.3.0以前に作成したTodoの移行と削除を完了")
            }
        } catch {
            print("エラーが発生しました")
        }
    }
    
    
}


// MARK: - テスト Todo

/// テスト用の配列
let testModel:[ToDoModel] = {
        
    let todo1 = ToDoModel()
    todo1.toDoName = "TODOName1"
    todo1.todoDate = Format().stringFromDate(date: Date())
    todo1.toDo = "TODO詳細1"
    todo1.createTime = "2020/01/01 00:00:01"
    
    let todo2 = ToDoModel()
    todo2.toDoName = "TODOName2"
    todo2.todoDate = Format().stringFromDate(date: Date())
    todo2.toDo = "TODO詳細2"
    todo2.createTime = "2020/01/01 00:00:02"
    
    let todo3 = ToDoModel()
    todo3.toDoName = "TODOName3"
    todo3.todoDate = Format().stringFromDate(date: Date())
    todo3.toDo = "TODO詳細3"
    todo3.createTime = "2020/01/01 00:00:03"
    
    
    let todo4 = ToDoModel()
    todo4.toDoName = "TODOName4"
    todo4.todoDate = Format().stringFromDate(date: Date())
    todo4.toDo = "TODO詳細4"
    todo4.createTime = "2020/01/01 00:00:04"

    
    return [todo1, todo2, todo3, todo4]
}()
