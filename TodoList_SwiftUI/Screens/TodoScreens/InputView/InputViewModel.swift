//
//  InputViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2021/01/17.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import Foundation
import Combine

final class InputViewModel: ObservableObject {
        
    /// Todoのタイトル
    @Published var toDoName: String = ""
    
    /// Model側に格納する期限の文字列
    private var todoDateStr: String = ""
    
    ///  画面側のTodoの期限
    @Published var toDoDate = Date()
    
    /// Todoの詳細
    @Published var toDo: String = ""
    
    /// 画面側の完了フラグ
    @Published var completionFlag: Bool = false
    
    /// TagのID
    @Published var tag_id: String = ""
    
    /// Tagセクションの表示フラグ
    private(set) var isTagSection = false
    
    /// Model側に格納する完了フラグの文字列
    private var completionFlagStr: CompletionFlag = .unfinished
    
    /// Modelのプライマリキー
    private var createTime: String?
    
    private var cancellable: Set<AnyCancellable> = []
    
    
    var tagList: [Tag] = []
    

    init(model: ToDoModel? = nil) {
        setModelValue(model)
        setDatePub()
        setCompletionFlagPub()
    }
    
    /// Modelから取得した値を書くプロパティにセットする
    private func setModelValue(_ model: ToDoModel?) {
        tagList = Tag.findAll(addEmptyTagFlag: true)
        
        isTagSection = tagList.isNotEmpty
        
        if let model {
            toDoName = model.toDoName
            todoDateStr = model.todoDate
            if let date = Format.dateFromString(string: model.todoDate) {
                toDoDate = date
            }
            toDo = model.toDo
            completionFlag = model.completionFlag == CompletionFlag.completion.rawValue ? true : false
            createTime = model.createTime
            tag_id = model.tag_id ?? ""
        }
    }
    
    /// 画面側の期限がセットされたら、文字列に変換しModel格納用の値に入れる
    private func setDatePub() {
        $toDoDate
            .map { date in
                Format.stringFromDate(date: date)
            }
            .print()
            .sink(receiveValue: { toDoDate in
                self.todoDateStr = toDoDate
            })
            .store(in: &cancellable)
    }
    
    
    /// 画面側の完了フラグがセットされたら、文字列に変換しModel格納用の値に入れる
    private func setCompletionFlagPub() {
        $completionFlag
            .print()
            .sink(receiveValue: { flag in
                self.completionFlagStr = flag ? .completion : .unfinished
            })
            .store(in: &cancellable)
    }
    
    
    /// Todoの追加
    func addTodo() throws {
        if let message = self.validateCheck() {
            throw TodoModelError(message: message)
        }
        
        do {
            try ToDoModel.add(addValue: ToDoModel(toDoName: self.toDoName, todoDate: self.todoDateStr, toDo: self.toDo, tag_id: self.tag_id))
        } catch {
            if let _error = error as? TodoModelError {
                throw _error
            }
            throw error
        }
    }
    
    
    /// Todoの更新
    func updateTodo() throws {
        if let message = self.validateCheck() {
            throw TodoModelError(message: message)
        }
        
        do {
            try ToDoModel.update(updateTodo: ToDoModel(toDoName: self.toDoName, todoDate: self.todoDateStr, toDo: self.toDo, completionFlag: self.completionFlagStr.rawValue, createTime: self.createTime, tag_id: self.tag_id))
        } catch {
            if let _error = error as? TodoModelError {
                throw _error
            }
            throw error
        }
    }
    
    
    /// バリデーションチェック
    /// - Returns: エラー文も返す
    func validateCheck() -> String? {
        if self.toDoName.isEmpty {
            return  R.string.message.validate(R.string.labels.title())
        } else if self.completionFlagStr == CompletionFlag.unfinished && self.todoDateStr <= Format.stringFromDate(date: Format.dateFormat()) {
            /// 完了フラグの未完であればあれば期限のバリデーションチェックを行う
            return R.string.message.validateDate()
        } else {
            return nil
        }
    }
    
}
