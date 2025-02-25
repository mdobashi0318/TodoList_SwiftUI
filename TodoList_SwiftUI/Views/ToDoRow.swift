//
//  ToDoRow.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import SwiftUI

/// TodoListに表示するセル
struct ToDoRow: View {
    
    let todoModel: ToDoModel
    
    private let cornerRadius: CGFloat = 6
 
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(lineWidth: 1)
            .frame(minHeight: 60)
            .foregroundStyle(.secondary)
            .background(Color.systemBackground)
            .cornerRadius(cornerRadius)
            .clipped()
            .shadow(color: .secondary.opacity(0.2), radius: cornerRadius)
            .overlay(content: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(todoModel.toDoName)
                            .animation(.none)
                            .accessibility(identifier: "titlelabel")
                        CompletionLable(todoDate: todoModel.todoDate, completionFlag: todoModel.completionFlag, isCompletionLabel: false)
                        if let tag_id = todoModel.tag_id,
                           let tag = Tag.find(id: tag_id) {
                            TagRow(tag: tag)
                                .padding(.top, -9.0)
                        }
                    }
                    .frame(alignment: .leading)
                    .padding()
                    Spacer()
                    UnevenRoundedRectangle(bottomTrailingRadius: cornerRadius, topTrailingRadius: cornerRadius, style: .continuous)
                        .foregroundStyle(completionType().backgroundColor)
                        .frame(width: 40)
                        .padding([.trailing, .bottom, .top], 1.5)
                        
                }
            })
    }
    
    
    
     private func completionType() -> CompletionType {
        switch todoModel.completionFlag {
        case CompletionFlag.completion.rawValue:
                return .complete
        default:
            return if Format.dateFromString(string: todoModel.todoDate) ?? Date() > Format.dateFormat() {
                .active
            } else {
                .expired
            }
        }
    }
    
    
}



// MARK: - Previews

struct ToDoRow_Previews: PreviewProvider {
    static var previews: some View {
        ToDoRow(todoModel: testModel[0])
            .previewLayout(.sizeThatFits)
        
        ToDoRow(todoModel: testModel[1])
            .previewLayout(.sizeThatFits)
    }
}

