//
//  CompletionLabel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2022/01/03.
//  Copyright © 2022 m.dobashi. All rights reserved.
//

import SwiftUI

/// 設定された期限とステータスを表示するラベル
struct CompletionLable: View {
    
    /// 期限
    let todoDate: String
    
    /// 完了フラグ
    var completionFlag: String
    
    var isCompletionLabel: Bool = true
    
    var body: some View {
        HStack {
            Text(todoDate)
                .animation(.none)
            if isCompletionLabel {
                if completionFlag == CompletionFlag.completion.rawValue {
                    let type = CompletionType.complete
                    /// 完了
                    Text(type.title)
                        .font(.subheadline)
                        .foregroundColor(type.backgroundColor)
                        .accessibility(identifier: "completeLabel")
                } else {
                    let type = CompletionType.isType(flag: CompletionFlag(rawValue: completionFlag) ?? .unfinished, date: todoDate)
                    /// 未完了or期限切れ
                    Text(type.title)
                        .font(.subheadline)
                        .foregroundColor(type.backgroundColor)
                        .accessibility(identifier: "dateLabel")
                }
            } else {
                EmptyView()
            }
        }
    }
}


// MARK: - Previews

struct CompletionLable_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CompletionLable(todoDate: testModel[0].todoDate, completionFlag: testModel[0].completionFlag)
                .previewLayout(.sizeThatFits)
            CompletionLable(todoDate: testModel[1].todoDate, completionFlag:  testModel[1].completionFlag)
                .previewLayout(.sizeThatFits)
            CompletionLable(todoDate: testModel[2].todoDate, completionFlag: testModel[2].completionFlag)
                .previewLayout(.sizeThatFits)
        }
    }
}
