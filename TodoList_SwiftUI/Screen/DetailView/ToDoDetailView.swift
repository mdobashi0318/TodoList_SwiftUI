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
    
    @State private var isShowErrorAlert = false
    
    
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    

    
    var body: some View {
        List {
            Section(header: Text("期限")
                        .font(.headline)) {
                HStack {
                    Text(viewModel.model?.todoDate ?? "")
                        .accessibility(identifier: "dateLabel")
                    if viewModel.model?.completionFlag == CompletionFlag.completion.rawValue {
                        Text(R.string.labels.complete())
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .accessibility(identifier: "completeLabel")
                    } else if viewModel.model?.todoDate != "" {
                        Text(Format().dateFromString(string: viewModel.model?.todoDate ?? "")! > Format().dateFormat() ? "" : R.string.labels.expired())
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            
            Section(header: Text("詳細")
                        .font(.headline)) {
                Text(viewModel.model?.toDo ?? "")
                    .accessibility(identifier: "todoDetaillabel")
            }
            
            completeToggleSection
        }
        .onAppear {
            viewModel.setFlag()
        }
        .alert(isPresented: $isShowErrorAlert) {
            Alert(title: Text("削除に失敗しました"))
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(viewModel.model?.toDoName ?? "")
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
            Image(systemName: "ellipsis")
        }
        .actionSheet(isPresented: $isActionSheet) {
            actionSheet
        }
        .sheet(isPresented: $isShowModle) {
            /// 編集を選択
            ToDoInputView(inputViewModel: InputViewModel(model: viewModel.model),
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
        ActionSheet(title: Text("Todoをどうしますか?"),
                    buttons: [ActionSheet.Button.default(Text("編集")) {
                        self.isShowModle.toggle()
                        }, .destructive(Text(R.string.labels.delete())) {
                            self.isDeleteAction.toggle()
                        }, .cancel(Text(R.string.labels.cancel()))
        ])
    }
    
    
    /// 削除確認アラート
    var deleteAlert: Alert {
        Alert(title: Text("Todoを削除しますか?"),
              primaryButton: .destructive(Text(R.string.labels.delete())) {
            do {
                viewModel.model = try ToDoViewModel().deleteTodo(delete: viewModel.model!)
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                self.isShowErrorAlert = true
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
