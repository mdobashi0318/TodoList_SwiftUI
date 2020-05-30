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
    
    @State var todoModel = ToDoModel()
    
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
            ToDoInputView(toDoModel: self.$todoModel, isUpdate: false)
        }
        .frame(width: 30, height: 30)
    }
    
    
    
    /// 全件削除ボタン
    var allDeleteButton : some View {
        Button(action: {
            self.isDeleteFlag.toggle()
        }) {
            Text("削除")
        }.alert(isPresented: self.$isDeleteFlag) {
            Alert(title: Text("全件削除しますか?"), primaryButton: .destructive(Text("削除")) {
                // TODO: 削除した後にクラッシュする
                ToDoModel.allDelete()
                }, secondaryButton: .cancel(Text("キャンセル")))
        }
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
            .navigationBarItems(leading: allDeleteButton ,trailing: addButton)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
