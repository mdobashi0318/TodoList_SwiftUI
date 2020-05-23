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
    
    @State var todoModel = ToDoModel()
    
    @State var isShowModle = false
    
    /// ToDo追加ボタン
    var addButton: some View {
        Button(action: {
            self.isShowModle.toggle()
        }) {
            Image(systemName: "plus.circle")
            .resizable()
        }
        .sheet(isPresented: $isShowModle) {
            ToDoInputView(toDoModel: self.$todoModel, isUpdate: false)
        }
        .frame(width: 30, height: 30)
    }
    
    
    var body: some View {
        NavigationView {
            List {
                if self.toDoviewModel.todoModel.count == 0 {
                    Text("ToDoが登録されていません")
                } else {
                    ForEach(self.toDoviewModel.todoModel, id: \.createTime) { toDoModel in
                        NavigationLink(destination: TodoDetailView(toDoModel: toDoModel)) {
                            ToDoRow(todoModel: toDoModel)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                self.toDoviewModel.objectWillChange.send()
            }
            .navigationBarTitle("ToDoList")
            .navigationBarItems(trailing: addButton)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
            .environmentObject(ToDoViewModel())
    }
}
