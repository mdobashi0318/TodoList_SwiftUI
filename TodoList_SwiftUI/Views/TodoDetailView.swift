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
    
    @Binding var toDoModel: ToDoModel
    
    /// Todoの編集するためのモーダルを出すフラグ
    @State var isShowModle = false
    
    /// アクションシートを出しフラグ
    @State var isActionSheet = false
    
    /// 削除確認アラートを出すフラグ
    @State var isDeleteAction = false
    
    @State var isShowErrorAlert = false
    
    
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    

    
    
    // MARK : Body
    
    var body: some View {
        List {
            Section(header: Text("期限")
                        .font(.headline)) {
                HStack {
                    Text(toDoModel.todoDate)
                        .accessibility(identifier: "dateLabel")
                    if toDoModel.todoDate != "" {
                        Text(Format().dateFromString(string: toDoModel.todoDate)! > Format().dateFormat() ? "" : "期限切れ")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            
            Section(header: Text("詳細")
                        .font(.headline)) {
                Text(toDoModel.toDo)
                    .accessibility(identifier: "todoDetaillabel")
            }
        }
        .alert(isPresented: $isShowErrorAlert) {
            Alert(title: Text("削除に失敗しました"))
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(toDoModel.toDoName)
        .navigationBarItems(trailing: addButton)
    }
}




// MARK: - UI

extension TodoDetailView {
    
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
            ToDoInputView(inputViewModel: InputViewModel(model: toDoModel),
                          isUpdate: true
            )
            .onDisappear {
                self.toDoModel = ToDoViewModel().findTodo(todoId: self.toDoModel.id, createTime: self.toDoModel.createTime ?? "")
            }
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
                        }, .cancel(Text("キャンセル"))
        ])
    }
    
    
    /// 削除確認アラート
    var deleteAlert: Alert {
        Alert(title: Text("Todoを削除しますか?"),
              primaryButton: .destructive(Text("削除")) {
                ToDoViewModel().deleteTodo(delete: toDoModel)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            self.presentationMode.wrappedValue.dismiss()
                        case .failure(let error):
                            self.isShowErrorAlert = true
                            print(error)
                        }
                    }, receiveValue: { dummy in
                        self.toDoModel = dummy
                    }).cancel()
              },
              secondaryButton: .cancel(Text("キャンセル"))
        )
    }
    
}


// MARK: - Previews

struct TodoDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodoDetailView(toDoModel: .constant(testModel[0]))
            //            .colorScheme(.dark)
            //            .background(Color(.systemBackground))
            //            .environment(\.colorScheme, .dark)
        }
    }
}
