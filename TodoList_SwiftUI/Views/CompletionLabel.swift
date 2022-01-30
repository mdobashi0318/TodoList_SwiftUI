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
    @Binding var completionFlag: String
    
    var body: some View {
        HStack {
            Text(todoDate)
            if completionFlag == CompletionFlag.completion.rawValue {
                /// 完了
                Text(R.string.labels.complete())
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .accessibility(identifier: "completeLabel")
            } else {
                /// 期限切れ
                Text(Format().dateFromString(string: todoDate) ?? Date() > Format().dateFormat() ? "" : R.string.labels.expired())
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .accessibility(identifier: "dateLabel")
            }
        }
    }
}


// MARK: - Previews

struct CompletionLable_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CompletionLable(todoDate: testModel[0].todoDate, completionFlag: .constant(testModel[0].completionFlag))
                .previewLayout(.sizeThatFits)
            CompletionLable(todoDate: testModel[1].todoDate, completionFlag: .constant( testModel[1].completionFlag))
                .previewLayout(.sizeThatFits)
            CompletionLable(todoDate: testModel[2].todoDate, completionFlag: .constant(testModel[2].completionFlag))
                .previewLayout(.sizeThatFits)
        }
    }
}
