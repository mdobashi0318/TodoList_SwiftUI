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
    
    @Binding var todoModel: ToDoModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(todoModel.toDoName)
                .accessibility(identifier: "titlelabel")
            CompletionLable(todoDate: todoModel.todoDate, completionFlag: $todoModel.completionFlag)
        }
        .frame(alignment: .leading)
        .padding()
    }
}



// MARK: - Previews

struct ToDoRow_Previews: PreviewProvider {
    static var previews: some View {
        ToDoRow(todoModel: .constant(testModel[0]))
            .previewLayout(.sizeThatFits)
        
        ToDoRow(todoModel: .constant(testModel[1]))
            .previewLayout(.sizeThatFits)
    }
}

