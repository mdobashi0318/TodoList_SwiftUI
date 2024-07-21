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
    
    @StateObject var viewModel: ViewModel
    
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
        Form {
            nameSection
            detailSection
            tagSection
            completeToggleSection
        }
        .alert(isPresented: $viewModel.isError) {
            Alert(title: Text(viewModel.errorMessage))
        }
        .listStyle(.grouped)
        .navigationTitle(viewModel.title)
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
    
    @ViewBuilder
    private var nameSection: some View {
        Section(header: Text(R.string.labels.deadline())
            .font(.headline)) {
                CompletionLable(todoDate: viewModel.date, completionFlag: viewModel.completionFlag)
            }
    }
    
    @ViewBuilder
    private var detailSection: some View {
        if !viewModel.detail.isEmpty {
            Section(header: Text(R.string.labels.details())
                .font(.headline)) {
                    Text(viewModel.detail)
                        .accessibility(identifier: "todoDetaillabel")
                }
        }
    }
    
    @ViewBuilder
    private var tagSection: some View {
        if let tag_id = viewModel.tagId,
           let tag = Tag.find(id: tag_id) {
            Section(header: Text(R.string.labels.tag())
                .font(.headline)) {
                    TagRow(tag: tag)
                }
        }
    }
    
    /// 編集/削除のアクションシート表示ボタン
    private var ellipsisButton: some View {
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
            ToDoInputView(viewModel: ToDoInputView.ViewModel(createTime: viewModel.createTime),
                          isUpdate: true)
            .onDisappear {
                viewModel.findTodo(createTime: viewModel.createTime)
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
    private var actionSheet: ActionSheet {
        ActionSheet(title: Text(R.string.message.detailActionSheet()),
                    buttons: [ActionSheet.Button.default(Text(R.string.labels.edit())) {
            self.isShowModle.toggle()
        }, .destructive(Text(R.string.labels.delete())) {
            self.isDeleteAction.toggle()
        }, .cancel(Text(R.string.labels.cancel()))
                             ])
    }
    
    
    /// 削除確認アラート
    private var deleteAlert: Alert {
        Alert(title: Text(R.string.message.deleteTodo()),
              primaryButton: .destructive(Text(R.string.labels.delete())) {
            if viewModel.deleteTodo() {
                self.presentationMode.wrappedValue.dismiss()
            }
        },
              secondaryButton: .cancel(Text(R.string.labels.cancel()))
        )
    }
    
    
    
    
    /// Todoの未完・完了トグル
    private var completeToggleSection: some View {
        return Section {
            Toggle(R.string.labels.complete(), isOn: $viewModel.isCompletion.animation())
                .accessibility(identifier: "completeSwitch")
        }
    }
    
}


// MARK: - Previews

struct TodoDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TodoDetailView(viewModel: TodoDetailView.ViewModel(createTime: testModel[0].createTime ?? "0"))
            //            .colorScheme(.dark)
            //            .background(Color(.systemBackground))
            //            .environment(\.colorScheme, .dark)
        }
    }
}
