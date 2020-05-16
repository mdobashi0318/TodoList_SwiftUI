//
//  ContentView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import SwiftUI

struct ToDoListView: View {
    
    @EnvironmentObject private var toDoviewModel: ToDoViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.toDoviewModel.todoModel, id: \.createTime) { toDoviewModel in
                    ToDoRow(todoModel: toDoviewModel)
                }
                .navigationBarTitle("ToDoList")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
        .environmentObject(ToDoViewModel())
    }
}
