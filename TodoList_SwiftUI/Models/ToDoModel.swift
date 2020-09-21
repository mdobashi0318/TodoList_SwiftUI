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
    
    @Published var todoModel: [ToDoModel] = ToDoModel.allFindRealm()!
    
    
    /// Todoを１件検索
    func findTodo(todoId: String, createTime: String) -> ToDoModel {
        let model = ToDoModel.findRealm(todoId: todoId, createTime: createTime)
        let todo = ToDoModel()
        todo.id = model?.id ?? ""
        todo.toDoName = model?.toDoName ?? ""
        todo.todoDate = model?.todoDate ?? ""
        todo.toDo = model?.toDo ?? ""
        
        return todo
    }
    
    
    
    
    
    /// Todoの追加
    func addTodo(add: ToDoModel?, success: ()->()?, failure: @escaping (String?)->()) {
        guard let _add = add else {
            return failure("Todoの追加に失敗しました")
        }
        
        ToDoModel.addRealm(addValue: _add) { error in
            if let _error = error {
                print(_error)
                failure("Todoの追加に失敗しました")
            } else {
                todoModel = ToDoModel.allFindRealm()!
                success()
            }
        }
    }
    
    
    /// Todoの更新
    func updateTodo(update: ToDoModel, success: () -> (), failure: @escaping (String?)->()) {
        ToDoModel.updateRealm(updateTodo: update, result: { error in
            if let _error = error {
                failure(_error)
                return
            }
            
            todoModel = ToDoModel.allFindRealm()!
            success()
        })
    }
    
    
    /// Todoの削除
    func deleteTodo(todoId: String, createTime: String, success: (ToDoModel) -> (), failure: @escaping (String?)->()) {
        ToDoModel.deleteRealm(todoId: todoId, createTime: createTime) { error in
            
            if let _error = error {
                failure(_error)
                return
            }
            todoModel = ToDoModel.allFindRealm()!
            /// 呼び出し元のTodoがnilになるとクラッシュするのでToDoの削除後に空のTodoを入れて回避する
            success(ToDoModel(id: "", toDoName: "", todoDate: "", toDo: "", createTime: ""))
        }
    }
    
    /// Realmのモデルを参照しない時はTestデータの配列を使う
//    @Published var todoModel: [ToDoModel] = todomodel

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
    
    
    
    // MARK: init
    
    convenience init(id: String, toDoName: String, todoDate: String, toDo: String, createTime: String?) {
        self.init()
        
        self.id = id
        self.toDoName = toDoName
        self.todoDate = todoDate
        self.toDo = toDo
        self.createTime = createTime
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
    ///   - addValue: 登録するTodoの値
    ///   - result: Todoの登録時のエラー
    /// - Returns: エラーがなければnil、あればエラーを返す
    class func addRealm(addValue:ToDoModel, result: (Error?) -> () ) {
        
        guard let realm = initRealm() else { return }
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
            result(nil)
        }
        catch {
            result(error)
        }
    
    }
    
    
    
    /// ToDoの更新
    /// - Parameters:
    ///   - updateTodo: 更新する値
    ///   - result: Todoの更新時のエラー
    /// - Returns: エラーがなければnil、あればエラーを返す
    class func updateRealm(updateTodo: ToDoModel, result: (String?) -> () ) {
        guard let realm = initRealm() else { return }
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
            result(nil)
        }
        catch {
            result("Todoの更新に失敗しました")
        }
        
    }
    
    
    /// １件取得
    /// - Parameters:
    ///   - todoId: TodoId
    ///   - createTime: Todoの作成時間
    /// - Returns: 取得したTodoの最初の1件を返す
    class func findRealm(todoId: String, createTime: String?) -> ToDoModel? {
        guard let realm = initRealm() else { return nil }
        
        if let _createTime = createTime {
            return (realm.objects(ToDoModel.self).filter("createTime == '\(String(describing: _createTime))'").first)
        } else {
            return (realm.objects(ToDoModel.self).filter("id == '\(String(describing: todoId))'").first!)
        }
        
    }
    
    
    /// 全件取得
    /// - Returns: 取得したTodoを全件返す
    class func allFindRealm() -> [ToDoModel]? {
        guard let realm = initRealm() else { return nil }
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
    
    
    /// ToDoの削除
    /// - Parameters:
    ///   - todoId: TodoId
    ///   - createTime: Todoの作成時間
    class func deleteRealm(todoId: String, createTime: String, result: (String?) -> () ) {
        guard let realm = initRealm() else { return }
        let toDoModel: ToDoModel = ToDoModel.findRealm(todoId: todoId, createTime: createTime)!
        NotificationManager().removeNotification([createTime])
        
        do {
            try realm.write() {
                realm.delete(toDoModel)
            }
            result(nil)
        }
            
        catch {
            result("ToDoの削除に失敗しました")
        }
          
    }
    
    
    /// 全件削除
    class func allDelete() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
        NotificationManager().allRemoveNotification()
    }
    
}

/// テスト用の配列
let todomodel:[ToDoModel] = {
        
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
