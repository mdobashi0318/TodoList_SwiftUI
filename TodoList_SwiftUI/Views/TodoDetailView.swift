//
//  TodoDetail.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/21.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import SwiftUI

struct TodoDetailView: View {
    @State var toDoModel: ToDoModel
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
            ToDoInputView(toDoModel: self.$toDoModel, isUpdate: true)
        }
        .frame(width: 30, height: 30)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("期限")
                Text(toDoModel.todoDate)
            }.frame(width: 300, height: 50, alignment: .leading)
            
            HStack {
                Text("詳細")
                Text(toDoModel.toDo)
            }.frame(width: 300, height: 50, alignment: .leading)
            Spacer()
        }
        .navigationBarTitle(toDoModel.toDoName)
    .navigationBarItems(trailing: addButton)
    }
}



struct TodoDetail_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailView(toDoModel: todomodel[0])
    }
}
