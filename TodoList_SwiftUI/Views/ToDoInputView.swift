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
    
    @Binding var viewModel: ToDoViewModel
    
    @Binding var toDoModel: ToDoModel
    
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    
    /// バリデーションアラートの表示フラグ
    @State var isValidate = false
    
    /// Todoの更新か追加かを判断
    @State var isUpdate: Bool
    
    /// datePickerで選択したDateを格納
    @State var tododate = Date()
    
    /// Todoの登録失敗アラートの表示フラグ
    @State var isAddError = false
    
    /// Todoの更新失敗アラートの表示フラグ
    @State var isUpdateError = false
    
    /// Alertの表示フラグ
    @State var isShowAlert = false
    
    
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            List {
                todoNameSection
                todoDatePicker
                todoDetailSection
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                if self.isUpdate {
                    /// 一度TodoModelにしてからTodoを操作する
                    self.toDoModel = viewModel.findTodo(todoId: toDoModel.id, createTime: toDoModel.createTime ?? "")
                    if let todoDate = Format().dateFromString(string: toDoModel.todoDate) {
                        self.tododate = todoDate
                    }
                }
            }
            .onDisappear {
                if !self.isUpdate {
                    self.toDoModel = ToDoModel()
                }
            }
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
            Image(systemName: "xmark.circle")
                .resizable()
        }
        .frame(width: 30, height: 30)
        .accessibility(identifier: "cancelButton")
    }
    
    
    /// ToDo追加ボタン
    private var addButton: some View {
        Button(action: {
            self.toDoModel.todoDate = Format().stringFromDate(date: self.tododate)
            self.validateCheck() { result in
                if result == false {
                    if !self.isUpdate {
                        self.addTodo()
                        
                    } else {
                        self.updateTodo()
                        
                    }
                } else {
                    self.isValidate = true
                    self.isShowAlert = true
                    
                }
            }
        }) {
            Image(systemName: "plus.circle")
                .resizable()
        }
        .frame(width: 30, height: 30)
        .alert(isPresented: $isShowAlert) {
            return showValidateAlert()
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
        if isRequiredLabel {
            requiredLabel
        }
        }
        .frame(width: UIScreen.main.bounds.width - 30, height: 30,alignment: .leading)
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
        return Section(header:
                        headerLabel(text: "タイトル", identifier: "titlelabel", isRequiredLabel: true)
                       , content: {
                        textField(placeholder: "タイトルを入力してください",
                                  text: $toDoModel.toDoName,
                                  identifier: "titleTextField"
                        )
                       })
    }
    
    
    /// 期限入力DatePicker
    private var todoDatePicker: some View {
        return Section() {
            DatePicker("期限", selection: self.$tododate)
            .accessibility(identifier: "todoDatePicker")
        }
    }
    
    
    /// 詳細入力テキストフィールド
    private var todoDetailSection: some View {
        return Section(header:
                        headerLabel(text: "詳細", identifier: "detailLabel", isRequiredLabel: true)
                       , content: {
                        textField(placeholder: "詳細を入力してください",
                                  text: $toDoModel.toDo,
                                  identifier: "detailTextField"
                        )
                       })
    }
    
    
}




// MARK: - Func

extension ToDoInputView {
    
    /// Todoの追加
    private func addTodo() {
        let id: String = String(ToDoModel.allFindRealm()!.count + 1)
        viewModel.addTodo(add: ToDoModel(id: id,
                                         toDoName: self.toDoModel.toDoName,
                                         todoDate: self.toDoModel.todoDate,
                                         toDo: self.toDoModel.toDo,
                                         createTime: nil
        ), success: {
            self.presentationMode.wrappedValue.dismiss()
        }, failure: { error in
            if let _error = error {
                print(_error)
            }
            self.isAddError = true
            self.isShowAlert = true
        })
    }
    
    
    /// Todoのアップデート
    private func updateTodo() {
        viewModel.updateTodo(update: ToDoModel(id: self.toDoModel.id,
                                               toDoName: self.toDoModel.toDoName,
                                               todoDate: self.toDoModel.todoDate,
                                               toDo: self.toDoModel.toDo,
                                               createTime: self.toDoModel.createTime),
                             success: {
                                self.presentationMode.wrappedValue.dismiss()
                             },
                             failure: { error in
                                self.isUpdateError = true
                                self.isShowAlert = true
                             })
    }
    
    
    /// バリデーションチェック
    /// テキストフィールドにテキストが入っていなければtrueを返し、アラートを表示させる
    private func validateCheck(callBack: (Bool) -> ()) {
        if toDoModel.toDoName.isEmpty || toDoModel.toDo.isEmpty {
            callBack(true)
            
        } else {
            callBack(false)
            
        }
    }
    
    
    /// バリデート時の表示するアラート
    private func showValidateAlert() -> Alert {
        if isAddError == true {
            return Alert(title: Text("Todoの登録に失敗しました"), dismissButton: .default(Text("閉じる")) {
                self.isAddError = false
            })
            
        } else if isUpdateError == true {
            return Alert(title: Text("Todoの更新に失敗しました"), dismissButton: .default(Text("閉じる")) {
                self.isUpdateError = false
            })
            
        } else {
            return Alert(title: Text("入力されていない項目があります"), dismissButton: .default(Text("閉じる")) {
                self.isValidate = false
            })
            
        }
    }
    
    
    private var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        return min...max
    }
    
}


// MARK: - Previews

struct ToDoInputView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToDoInputView(viewModel: .constant(ToDoViewModel()), toDoModel: .constant(ToDoModel()), isUpdate: false)
            ToDoInputView(viewModel: .constant(ToDoViewModel()), toDoModel: .constant(ToDoModel()), isUpdate: true)
        }
    }
}
