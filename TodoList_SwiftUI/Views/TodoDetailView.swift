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
    
    /// Todoの編集するためのモーダルを出すフラグ
    @State var isShowModle = false
    
    /// アクションシートを出しフラグ
    @State var isActionSheet = false
    
    /// 削除確認アラートを出すフラグ
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
            actionSheet
        }
        .sheet(isPresented: $isShowModle) {
            /// 編集を選択
            ToDoInputView(toDoModel: self.$toDoModel, isUpdate: true)
        }
        .alert(isPresented: $isDeleteAction) {
            /// 削除を選択
            deleteAlert
        }
        .frame(width: 30, height: 30)
    }
    
    
    
    /// Todoの編集、削除の選択をするアクションシートを出す
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Todoをどうしますか?"),
                    buttons: [ActionSheet.Button.default(Text("編集")) {
                        self.isShowModle.toggle()
                        }, .destructive(Text("削除")) {
                            self.isDeleteAction.toggle()
                        },
                           .cancel(Text("キャンセル"))
        ])
    }
    
    
    /// 削除確認アラート
    var deleteAlert: Alert {
        Alert(title: Text("Todoを削除しますか?"),
              primaryButton: .destructive(Text("削除")) {
                // TODO: 削除した後にクラッシュする
                ToDoModel.deleteRealm(todoId: self.toDoModel.id, createTime: self.toDoModel.createTime) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            },
              secondaryButton: .cancel(Text("キャンセル"))
        )
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
    }
}



struct TodoDetail_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailView(toDoModel: todomodel[0])
    }
}
