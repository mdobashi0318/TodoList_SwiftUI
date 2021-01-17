//
//  Errors.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2021/01/18.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import Foundation


// MARK: TodoModelError

struct TodoModelError: Error {
    var isError: Bool = false
    var message: String = ""
    
    init(isError: Bool) {
        self.isError = isError
    }
    
    init(message: String) {
        self.message = message
    }
}


// MARK: DeleteError

struct DeleteError: Error {
    var model: ToDoModel
    var message: String
}
