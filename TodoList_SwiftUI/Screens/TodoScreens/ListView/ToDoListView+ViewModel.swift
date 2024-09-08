//
//  ToDoViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/09/21.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - ViewModel

extension ToDoListView {
    
    class ViewModel: ObservableObject {
        
        @Published private(set) var todoModel: [ToDoModel] = []
        
        @Published var segmentIndex: SegmentIndex = .all
        
        @Published var searchTagId = ""
        /// Todo追加画面のモーダル表示フラグ
        @Published var isShowModle = false
        /// 全件削除の確認アラートの表示フラグ
        @Published var isDeleteFlag = false
        /// Tagリスト画面のモーダル表示フラグ
        @Published var isShowTagModle = false
        
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
