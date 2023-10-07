//
//  TodoButton.swift
//  TodoWidgetExtension
//
//  Created by 土橋正晴 on 2023/09/30.
//

import SwiftUI

@available(iOS 17.0, *)
struct TodoButton: View {
    let createTime: String
    
    var body: some View {
        Button(intent: TodoWidgetAppIntent(createTime), label: {
            Text(NSLocalizedString("Complete", tableName: "Label", comment: ""))
        })
    }
}

@available(iOS 17.0, *)
#Preview {
    TodoButton(createTime: "")
}
