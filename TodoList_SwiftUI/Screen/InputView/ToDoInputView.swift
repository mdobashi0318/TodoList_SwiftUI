//
//  ToDoInputView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/17.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import SwiftUI

struct ToDoInputView: View {
    
    
    // MARK: Properties
    
    @ObservedObject var viewModel: InputViewModel
    
    
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    /// Todoの更新か追加かを判断
    @State var isUpdate: Bool
    
    /// Alertの表示フラグ
    @State private var isShowAlert = false
    
    /// エラーメッセージ
    @State private var errorMessage: String = ""
    
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            List {
                todoNameSection
                todoDatePicker
                todoDetailSection
                if isUpdate { completeToggleSection }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(isUpdate ? R.string.labels.updateToDo() : R.string.labels.addToDo())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .accessibility(identifier: "ToDoInputView")
        }
        
    }
    
    
}




// MARK: - UI

extension ToDoInputView {
    
    /// キャンセルボタン
    private var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .accessibilityLabel(R.string.labels.close())
        }
        .accessibility(identifier: "cancelButton")
    }
    
    
    /// ToDo追加ボタン
    private var addButton: some View {
        Button(action: {
            if !self.isUpdate {
                self.addTodo()
            } else {
                self.updateTodo()
            }
        }) {
            Image(systemName: "plus")
                .resizable()
                .accessibilityLabel(R.string.labels.add())
        }
        .alert(isPresented: $isShowAlert) {
            return showValidateAlert
        }
        .accessibility(identifier: "todoAddButton")
        
    }
    
    
    
    /// 「*必須」ラベル
    private var requiredLabel: some View {
        return Text(R.string.labels.required())
            .font(.caption)
            .foregroundColor(.red)
    }
    
    
    
    /// ヘッダーラベル
    /// - Parameters:
    ///   - text: テキスト
    ///   - identifier: identifier
    ///   - isRequiredLabel: 必須ラベルの表示判定
    private func headerLabel(text: String, identifier: String, isRequiredLabel: Bool) -> some View {
        HStack {
            Text(text)
                .font(.headline)
                .accessibility(identifier: identifier)
            if isRequiredLabel { requiredLabel }
        }
    }
    
    
    
    /// テキストフィールド
    /// - Parameters:
    ///   - placeholder: プレースホルダー
    ///   - text: テキスト
    ///   - identifier: identifier
    private func textField(placeholder: String, text: Binding<String>, identifier: String) -> some View {
        TextField(placeholder, text: text)
            .accessibility(identifier: identifier)
    }
    
    
    /// タイトル入力テキストフィールド
    private var todoNameSection: some View {
        return Section(header: headerLabel(text: R.string.labels.title(), identifier: "titlelabel", isRequiredLabel: true)) {
            textField(placeholder: R.string.message.inputTitle(),
                      text: $viewModel.toDoName,
                      identifier: "titleTextField"
            )
        }
    }
    
    
    /// 期限入力DatePicker
    private var todoDatePicker: some View {
        return Section() {
            DatePicker(R.string.labels.deadline(), selection: $viewModel.toDoDate, in: Date()...)
                .accessibility(identifier: "todoDatePicker")
        }
    }
    
    
    /// 詳細入力テキストフィールド
    private var todoDetailSection: some View {
        return Section(header: headerLabel(text: R.string.labels.details(), identifier: "detailLabel", isRequiredLabel: true)) {
            textField(placeholder: R.string.message.inputDetails(),
                      text: $viewModel.toDo,
                      identifier: "detailTextField"
            )
        }
    }
    
    
    /// Todoの未完・完了トグル
    private var completeToggleSection: some View {
        return Section {
            Toggle(R.string.labels.complete(), isOn: $viewModel.completionFlag)
                .accessibility(identifier: "completeSwitch")
        }
    }
    
    /// バリデート時の表示するアラート
    private var showValidateAlert: Alert {
        return Alert(title: Text(self.errorMessage), dismissButton: .default(Text(R.string.labels.close())))
    }
    
}




// MARK: - Func

extension ToDoInputView {
    
    /// Todoの追加
    private func addTodo() {
        
        do {
            try viewModel.addTodo()
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            if let _error = error as? TodoModelError {
                self.errorMessage = _error.message
            }
            self.isShowAlert = true
        }
    }
    
    
    /// Todoのアップデート
    private func updateTodo() {
        do {
            try viewModel.updateTodo()
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            if let _error = error as? TodoModelError {
                self.errorMessage = _error.message
            }
            self.isShowAlert = true
        }
        
    }
    
}


// MARK: - Previews

struct ToDoInputView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToDoInputView(viewModel: InputViewModel(), isUpdate: false)
            ToDoInputView(viewModel: InputViewModel(model: testModel[0]), isUpdate: true)
        }
    }
}
