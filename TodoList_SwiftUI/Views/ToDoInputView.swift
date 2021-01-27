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
    
    @ObservedObject var inputViewModel: InputViewModel
    
    
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    
    /// Todoの更新か追加かを判断
    @State var isUpdate: Bool
    
    /// Alertの表示フラグ
    @State var isShowAlert = false
    
    /// エラーメッセージ
    @State var errorMessage: String = ""
    
    
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
            .navigationBarTitle(isUpdate ? "ToDo更新" : "ToDo追加")
            .navigationBarItems(leading: cancelButton ,trailing: addButton)
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
        }
        .alert(isPresented: $isShowAlert) {
            return showValidateAlert
        }
        .accessibility(identifier: "todoAddButton")
        
    }
    
    
    
    /// 「*必須」ラベル
    private var requiredLabel: some View {
        return Text("*必須")
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
        return Section(header: headerLabel(text: "タイトル", identifier: "titlelabel", isRequiredLabel: true)) {
            textField(placeholder: "タイトルを入力してください",
                      text: $inputViewModel.toDoName,
                      identifier: "titleTextField"
            )
        }
    }
    
    
    /// 期限入力DatePicker
    private var todoDatePicker: some View {
        return Section() {
            DatePicker("期限", selection: $inputViewModel.toDoDate, in: Date()...)
            .accessibility(identifier: "todoDatePicker")
        }
    }
    
    
    /// 詳細入力テキストフィールド
    private var todoDetailSection: some View {
        return Section(header: headerLabel(text: "詳細", identifier: "detailLabel", isRequiredLabel: true)) {
            textField(placeholder: "詳細を入力してください",
                      text: $inputViewModel.toDo,
                      identifier: "detailTextField"
            )
        }
    }
    
    
    /// Todoの未完・完了トグル
    private var completeToggleSection: some View {
        return Section {
            Toggle(R.string.labels.complete(), isOn: $inputViewModel.completionFlag)
                .accessibility(identifier: "completeSwitch")
        }
    }
    
    /// バリデート時の表示するアラート
    private var showValidateAlert: Alert {
        return Alert(title: Text(self.errorMessage), dismissButton: .default(Text(R.string.alertMessage.close())))
    }
    
}




// MARK: - Func

extension ToDoInputView {
    
    /// Todoの追加
    private func addTodo() {
        inputViewModel.addTodo()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    print(error)
                    self.errorMessage = error.message
                    self.isShowAlert = true
                }
            }, receiveValue: {
            }).cancel()
    }
    
    
    /// Todoのアップデート
    private func updateTodo() {
        inputViewModel.updateTodo()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    print(error)
                    self.errorMessage = error.message
                    self.isShowAlert = true
                }
            }, receiveValue: {
            }).cancel()
    }
    
}


// MARK: - Previews

struct ToDoInputView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToDoInputView(inputViewModel: InputViewModel(), isUpdate: false)
            ToDoInputView(inputViewModel: InputViewModel(model: testModel[0]), isUpdate: true)
        }
    }
}
