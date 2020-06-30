//
//  ToDoInputView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/17.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import SwiftUI

struct ToDoInputView: View {
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
    
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        return min...max
    }
    
    
    
    /// 更新するTodoを返す
    func todoUpdate(_ model: ToDoModel) -> ToDoModel {
        let todo = ToDoModel()
        todo.id = model.id
        todo.toDoName = model.toDoName
        todo.todoDate = model.todoDate
        todo.toDo = model.toDo
        
        return todo
    }
    
    
    
    /// キャンセルボタン
    var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle")
                .resizable()
        }
        .frame(width: 30, height: 30)
        .accessibility(identifier: "cancelButton")
    }
    
    
    
    
    
    
    fileprivate func addTodo() {
        let id: String = String(ToDoModel.allFindRealm()!.count + 1)
        ToDoModel.addRealm(addValue:
            ToDoModel(id: id,
                       toDoName: self.toDoModel.toDoName,
                       todoDate: self.toDoModel.todoDate,
                       toDo: self.toDoModel.toDo,
                       createTime: nil
        )) { error in
            
            if let _error = error {
                print(_error)
                self.isAddError = true
                self.isShowAlert = true
                
            } else {
                self.presentationMode.wrappedValue.dismiss()
                
            }
        }
    }
    
    fileprivate func updateTodo() {
        ToDoModel.updateRealm(updateTodo: ToDoModel(id: self.toDoModel.id,
                                                     toDoName: self.toDoModel.toDoName,
                                                     todoDate: self.toDoModel.todoDate,
                                                     toDo: self.toDoModel.toDo,
                                                     createTime: self.toDoModel.createTime
        )) { error in
            
            if let _error = error {
                print(_error)
                self.isUpdateError = true
                self.isShowAlert = true
                
            } else {
                self.presentationMode.wrappedValue.dismiss()
                
            }
        }
    }
    
    /// ToDo追加ボタン
    var addButton: some View {
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
            if isAddError {
                return Alert(title: Text("Todoの登録に失敗しました"), dismissButton: .default(Text("閉じる")) {
                    self.isAddError = false
                    })
                
            } else if isUpdateError {
                return Alert(title: Text("Todoの更新に失敗しました"), dismissButton: .default(Text("閉じる")) {
                    self.isUpdateError = false
                    })
                
            } else {
                return Alert(title: Text("入力されていない項目があります"), dismissButton: .default(Text("閉じる")) {
                    self.isValidate = false
                    })
                
            }
        }
            
        .accessibility(identifier: "todoAddButton")
    }
    
    
    /// バリデーションチェック
    /// テキストフィールドにテキストが入っていなければtrueを返し、アラートを表示させる
    func validateCheck(callBask: (Bool) -> ()) {
        if toDoModel.toDoName.isEmpty || toDoModel.toDo.isEmpty {
            callBask(true)
            
        } else {
            callBask(false)
            
        }
    }
    
    /// 「*必須」ラベル
    fileprivate func requiredLabel() -> Text {
        return Text("*必須")
            .font(.caption)
            .foregroundColor(.red)
    }
    
    /// タイトル入力テキストフィールド
    fileprivate func todoNameTextField() -> some View {
        return VStack(alignment: .leading) {
            HStack {
                Text("タイトル")
                    .font(.headline)
                    .accessibility(identifier: "titlelabel")
                requiredLabel()
            }
            TextField("タイトルを入力してください", text: $toDoModel.toDoName)
                .accessibility(identifier: "titleTextField")
        }
        .frame(height: 50, alignment: .leading)
        .padding(.top)
    }
    
    
    /// 期限入力DatePicker
    fileprivate func todoDatePicker() -> some View {
        return VStack(alignment: .leading) {
            DatePicker(selection: self.$tododate, in: dateRange) {
                Text("期限")
                    .font(.headline)
                    .accessibility(identifier: "todoDateLabel")
            }
            .accessibility(identifier: "todoDatePicker")
        }
        .padding(.top)
    }
    
    
    /// 詳細入力テキストフィールド
    fileprivate func todoDetailTextField() -> some View {
        return VStack(alignment: .leading) {
            HStack {
                Text("詳細")
                    .font(.headline)
                    .accessibility(identifier: "detailLabel")
                requiredLabel()
            }
            TextField("詳細を入力してください", text: $toDoModel.toDo)
            .accessibility(identifier: "detailTextField")
            
        }
        .frame(height: 50, alignment: .leading)
        .padding(.top)
    }
    
    
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HStack {
                    cancelButton
                    Spacer()
                    addButton
                }
                Divider()
                todoNameTextField()
                todoDatePicker()
                todoDetailTextField()
                Spacer()
            }
            .frame(height: UIScreen.main.bounds.height)
        }
        .padding()
        .onAppear {
            if self.isUpdate {
                self.toDoModel = self.todoUpdate(self.toDoModel)
            }
        }
        .onDisappear {
            if !self.isUpdate {
                self.toDoModel = ToDoModel()
            }
        }
        .accessibility(identifier: "ToDoInputView")
    }
    
    
}

struct ToDoInputView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoInputView(toDoModel: .constant(ToDoModel()), isUpdate: false)
    }
}
