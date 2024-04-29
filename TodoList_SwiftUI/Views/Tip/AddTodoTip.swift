//
//  AddTodoTip.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2024/04/10.
//

import TipKit

@available(iOS 17.0, *)
struct AddTodoTip: Tip {
    var title: Text {
        Text(R.string.message.tipAddTodoTitle)
    }


    var message: Text? {
        Text(R.string.message.tipAddTodoMessage)
    }
}

