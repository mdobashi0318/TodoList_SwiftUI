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
            Text(todoModel.todoDate!)
            Divider()
        }
        .padding()
    }
}

struct ToDoRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ToDoRow(todoModel: (ToDoModel.allFindRealm()?[0])!)
            .previewLayout(.fixed(width: 300, height: 50))
    }
}
