//
//  ToDoRow.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import SwiftUI

struct ToDoRow: View {
    
    let todoModel: ToDoModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(todoModel.toDoName)
                .accessibility(identifier: "titlelabel")
            CompletionLable(todoDate: todoModel.todoDate, completionFlag: .constant(todoModel.completionFlag))
        }
        .frame(alignment: .leading)
        .padding()
    }
}

struct ToDoRow_Previews: PreviewProvider {
    static var previews: some View {
        ToDoRow(todoModel: testModel[0])
            .previewLayout(.sizeThatFits)
        
        ToDoRow(todoModel: testModel[1])
            .previewLayout(.sizeThatFits)
    }
}

