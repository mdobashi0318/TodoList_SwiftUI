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
    @State var isActionSheet = false
    @State var isDeleteAction = false
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    
    /// ToDo追加ボタン
    var addButton: some View {
        Button(action: {
            self.isActionSheet.toggle()
        }) {
            Image(systemName: "plus.circle")
                .resizable()
        }
        .actionSheet(isPresented: $isActionSheet) {
            ActionSheet(title: Text("Todoをどうしますか?"),
                        buttons: [ActionSheet.Button.default(Text("更新")) {
                            print("更新画面へ")
                            self.isShowModle.toggle()
                            }, .destructive(Text("削除")) {
                                self.isDeleteAction.toggle()
                            },
                               .cancel(Text("キャンセル"))
            ])
            
        }
        .sheet(isPresented: $isShowModle) {
            ToDoInputView(toDoModel: self.$toDoModel, isUpdate: true)
        }
        .alert(isPresented: $isDeleteAction) {
            Alert(title: Text("Todoを削除しますか?"),
                  primaryButton: .destructive(Text("削除")) {
                    ToDoViewModel.del(self.toDoModel)
                    self.presentationMode.wrappedValue.dismiss()
                    },
                  secondaryButton: .cancel(Text("キャンセル"))
            )
        }
            
        .frame(width: 30, height: 30)
    }
    
    var body: some View {
        List {
            HStack {
                Text("期限")
                Text(toDoModel.todoDate)
            }.frame(width: 300, height: 50, alignment: .leading)
            
            HStack {
                Text("詳細")
                Text(toDoModel.toDo)
            }.frame(width: 300, height: 50, alignment: .leading)
        }
        .navigationBarTitle(toDoModel.toDoName)
        .navigationBarItems(trailing: addButton)
        .onDisappear {
//            print("isDetailLink: \(self.isDetailLink)")
        }
    }
}



struct TodoDetail_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailView(toDoModel: todomodel[0])
    }
}
