//
//  ToDoViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/09/21.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum SegmentIndex: Int, CaseIterable {
    case all = 0
    case active = 1
    case expired = 2
    case complete = 3
}


final class ToDoViewModel: ObservableObject {
    
    @Published var todoModel: [ToDoModel] = []
    
    @Published var segmentIndex: SegmentIndex = .all
    
    @Published var searchTagId = ""
    
    var tagModel: [Tag] = []
        
    var isAlertError: Bool = false
    
    
    init() {
        Task {
            await fetchAllTodoModel()
            await fetchAllTag()
        }
        
    }
    
    /// Todoを全件取得する
    @MainActor
    func fetchAllTodoModel() async {
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
    func allDeleteTodo() {
        ToDoModel.allDelete()
        self.todoModel = []
    }
    
    @MainActor
    func fetchAllTag() {
        tagModel = Tag.findAll(addEmptyTagFlag: true)
    }

}

