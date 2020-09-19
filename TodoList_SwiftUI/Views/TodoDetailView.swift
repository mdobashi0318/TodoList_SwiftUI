//
//  TodoDetail.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/21.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import SwiftUI

struct TodoDetailView: View {
    
    // MARK: Properties
    
    @State var toDoModel: ToDoModel
    
    /// Todoの編集するためのモーダルを出すフラグ
    @State var isShowModle = false
    
    /// アクションシートを出しフラグ
    @State var isActionSheet = false
    
    /// 削除確認アラートを出すフラグ
    @State var isDeleteAction = false
    
    
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    
    
    
    // MARK: UI
    
    /// ToDo追加ボタン
    var addButton: some View {
        Button(action: {
            self.isActionSheet.toggle()
        }) {
            Image(systemName: "ellipsis.circle")
                .resizable()
        }
        .actionSheet(isPresented: $isActionSheet) {
            actionSheet
        }
        .sheet(isPresented: $isShowModle) {
            /// 編集を選択
            ToDoInputView(viewModel: .constant(ToDoViewModel()), toDoModel: self.$toDoModel, isUpdate: true)
        }
        .alert(isPresented: $isDeleteAction) {
            /// 削除を選択
            deleteAlert
        }
        .frame(width: 30, height: 30)
        .accessibility(identifier: "todoActionButton")
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
                
                ToDoModel.deleteRealm(todoId: self.toDoModel.id, createTime: self.toDoModel.createTime, returnValue: { todo in
                    /// Todoを削除した時にText()がnilになるためかアプリが落ちるので空のTodoをいれる
                    self.toDoModel = todo
                }) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            },
              secondaryButton: .cancel(Text("キャンセル"))
        )
    }
    
    
    // MARK : Body
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            Text("期限")
                .font(.headline)
                .padding(.top)
            HStack {
                Text(toDoModel.todoDate)
                    .accessibility(identifier: "dateLabel")
                if toDoModel.todoDate != "" {
                    Text(Format().dateFromString(string: toDoModel.todoDate)! > Format().dateFormat() ? "" : "期限切れ")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            Divider()
            
            Text("詳細")
                .font(.headline)
                .padding(.top)
            Text(toDoModel.toDo)
                .accessibility(identifier: "todoDetaillabel")
            
            Divider()
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .padding(.leading)
        .navigationBarTitle(toDoModel.toDoName)
        .navigationBarItems(trailing: addButton)
    }
}



// MARK: - Previews

struct TodoDetail_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailView(toDoModel: todomodel[0])
//            .colorScheme(.dark)
//            .background(Color(.systemBackground))
//            .environment(\.colorScheme, .dark)
    }
}
