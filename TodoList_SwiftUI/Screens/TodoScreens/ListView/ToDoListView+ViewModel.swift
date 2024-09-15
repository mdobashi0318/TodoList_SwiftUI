//
//  ToDoViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/09/21.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import Observation

// MARK: - ViewModel

extension ToDoListView {
    
    @Observable
    class ViewModel {
        
        private(set) var todoModel: [ToDoModel] = []
        
        var segmentIndex: SegmentIndex = .all
        
        var searchTagId = ""
        /// Todo追加画面のモーダル表示フラグ
        var isShowModle = false
        /// 全件削除の確認アラートの表示フラグ
        var isDeleteFlag = false
        /// Tagリスト画面のモーダル表示フラグ
        var isShowTagModle = false
        
        private(set) var tagModel: [Tag] = []
        
        var isAlertError: Bool = false
        
        
        init() {
            fetchAllTag()
        }
        
        /// Todoを全件取得する
        func fetchAllTodoModel() {
            todoModel = switch segmentIndex {
            case .active:
                ToDoModel.allFindTodo(tagId: searchTagId).filter {
                    Format.dateFromString(string: $0.todoDate)! > Format.dateFormat() && $0.completionFlag != CompletionFlag.completion.rawValue
                }
            case .expired:
                ToDoModel.allFindTodo(tagId: searchTagId).filter {
                    $0.todoDate <= Format.stringFromDate(date: Date()) && $0.completionFlag != CompletionFlag.completion.rawValue
                }
            case .complete:
                ToDoModel.allFindTodo(tagId: searchTagId).filter {
                    $0.completionFlag == CompletionFlag.completion.rawValue
                }
            case .all:
                ToDoModel.allFindTodo(tagId: searchTagId)
            }
        }
        
        
        /// Todoを全件削除する
        @MainActor
        func allDeleteTodo() async {
            ToDoModel.allDelete()
        }
        
        func todoModelDelete() {
            todoModel = []
        }
        
        func fetchAllTag() {
            tagModel = Tag.findAll(addEmptyTagFlag: true)
        }
        
    }
    
}
