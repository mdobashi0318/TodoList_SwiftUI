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
            HStack {
                Text(todoModel.todoDate)
                Text(Format().dateFromString(string: todoModel.todoDate)! > Format().dateFormat() ? "" : "期限切れ")
                    .font(.caption)
                    .foregroundColor(.red)
                    .accessibility(identifier: "dateLabel")
            }
        }
        .frame(alignment: .leading)
        .padding()
    }
}

struct ToDoRow_Previews: PreviewProvider {
    static var previews: some View {
        ToDoRow(todoModel: testModel[0])
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 60))
    }
}

