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
    
    @ObservedObject var viewModel: TodoDetailViewModel
    
    /// Todoの編集するためのモーダルを出すフラグ
    @State private var isShowModle = false
    
    /// アクションシートを出しフラグ
    @State private var isActionSheet = false
    
    /// 削除確認アラートを出すフラグ
    @State private var isDeleteAction = false
     
    /// ellipsisButtonの表示非表示を設定
    ///
    /// - default: true
    var isDisplayEllipsisBtn = true
    
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    
    var body: some View {
        List {
            Section(header: Text(R.string.labels.deadline())
                        .font(.headline)) {
                CompletionLable(todoDate: viewModel.model.todoDate, completionFlag: $viewModel.model.completionFlag)
            }
            
            Section(header: Text(R.string.labels.details())
                        .font(.headline)) {
                Text(viewModel.model.toDo)
                    .accessibility(identifier: "todoDetaillabel")
            }
            
            completeToggleSection
        }
        .onAppear {
            viewModel.setFlag()
        }
        .alert(isPresented: $viewModel.isError) {
            Alert(title: Text(viewModel.errorMessage))
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(viewModel.model.toDoName)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isDisplayEllipsisBtn {
                    ellipsisButton
                }
            }
        }
        
    }
    
}




// MARK: - UI

extension TodoDetailView {
    
    /// 編集/削除のアクションシート表示ボタン
    var ellipsisButton: some View {
        Button(action: {
            self.isActionSheet.toggle()
        }) {
            Image(systemName: "ellipsis")
        }
        .actionSheet(isPresented: $isActionSheet) {
            actionSheet
        }
        .sheet(isPresented: $isShowModle) {
            /// 編集を選択
            ToDoInputView(viewModel: InputViewModel(model: viewModel.model),
                          isUpdate: true
            )
            .onDisappear {
                viewModel.findTodo()
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
        ActionSheet(title: Text(R.string.message.detailActionSheet()),
                    buttons: [ActionSheet.Button.default(Text(R.string.labels.edit())) {
                        self.isShowModle.toggle()
                        }, .destructive(Text(R.string.labels.delete())) {
                            self.isDeleteAction.toggle()
                        }, .cancel(Text(R.string.labels.cancel()))
        ])
    }
    
    
    /// 削除確認アラート
    var deleteAlert: Alert {
        Alert(title: Text(R.string.message.deleteTodo()),
              primaryButton: .destructive(Text(R.string.labels.delete())) {
            do {
                viewModel.model = try ToDoViewModel().deleteTodo(delete: viewModel.model)
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                viewModel.errorMessage = R.string.message.deleteError()
                viewModel.isError = true
            }
        },
              secondaryButton: .cancel(Text(R.string.labels.cancel()))
        )
    }
    
    
    
    
    /// Todoの未完・完了トグル
    private var completeToggleSection: some View {
        return Section {
            Toggle(R.string.labels.complete(), isOn: $viewModel.completionFlag)
                .accessibility(identifier: "completeSwitch")
        }
    }
    
}


// MARK: - Previews

struct TodoDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodoDetailView(viewModel: TodoDetailViewModel(model: testModel[0]))
            //            .colorScheme(.dark)
            //            .background(Color(.systemBackground))
            //            .environment(\.colorScheme, .dark)
        }
    }
}
