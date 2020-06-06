//
//  ContentView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import SwiftUI

struct ToDoListView: View {
    
    @ObservedObject private var toDoviewModel = ToDoViewModel()
    
    @State var isShowModle = false
    
    @State var isDeleteFlag = false
    
    
    /// ToDoの追加画面に遷移させるボタン
    var addButton: some View {
        Button(action: {
            self.isShowModle.toggle()
        }) {
            Image(systemName: "plus.circle")
            .resizable()
        }
        .sheet(isPresented: $isShowModle) {
            ToDoInputView(toDoModel: .constant(ToDoModel()), isUpdate: false)
        }
        .frame(width: 30, height: 30)
        .accessibility(identifier: "addButton")
    }
    
    
    
    /// 全件削除ボタン
    var allDeleteButton : some View {
        Button(action: {
            self.isDeleteFlag.toggle()
        }) {
            Text("削除")
        }.alert(isPresented: self.$isDeleteFlag) {
            Alert(title: Text("全件削除しますか?"), primaryButton: .destructive(Text("削除")) {
                ToDoModel.allDelete()
                }, secondaryButton: .cancel(Text("キャンセル")))
        }
        .accessibility(identifier: "allDeleteButton")
    }
    
    
    
    var body: some View {
        NavigationView {
            List {
                if self.toDoviewModel.todoModel.count == 0 {
                    Text("ToDoが登録されていません")
                } else {
                    ForEach(0..<self.toDoviewModel.todoModel.count, id: \.self) { row in
                        NavigationLink(destination: TodoDetailView(toDoModel: self.toDoviewModel.todoModel[row])) {
                            ToDoRow(todoModel: self.toDoviewModel.todoModel[row])
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                self.toDoviewModel.objectWillChange.send()
            }
            .navigationBarTitle("ToDoList")
            .navigationBarItems(leading: allDeleteButton ,trailing: addButton)
        }
        .accessibility(identifier: "ToDoList")
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
