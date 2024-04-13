//
//  TagTip.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2024/04/12.
//

import TipKit

@available(iOS 17.0, *)
struct TagTip: Tip {
    var title: Text {
        Text(R.string.message.tipTagTitle)
    }

    var message: Text? {
        Text(R.string.message.tipTagMessage)
    }
}
