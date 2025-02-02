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
 
    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .foregroundStyle(.clear)
            .padding()
            .background(completionType().backgroundColor.opacity(0.4))
            .cornerRadius(8)
            .clipped()
            .shadow(color: .gray.opacity(0.7), radius: 5)
            .frame(minHeight: 60, alignment: .leading)
            .overlay(content: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(todoModel.toDoName)
                            .animation(.none)
                            .accessibility(identifier: "titlelabel")
                        CompletionLable(todoDate: todoModel.todoDate, completionFlag: todoModel.completionFlag)
                        if let tag_id = todoModel.tag_id,
                           let tag = Tag.find(id: tag_id) {
                            TagRow(tag: tag)
                        }
                    }
                    .frame(alignment: .leading)
                    .padding()
                    Spacer()
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

