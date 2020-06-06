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
    
    /// 項目が入力されているかの判断し、入力されていなければアラートを表示させる
    ///
    /// true:  入力されていない項目があるのでアラートを表示させる
    /// false: 項目が入力されているのでTodoの追加、更新処理をする
    @State var isValidate = false
    
    /// Todoの更新か追加かを判断
    @State var isUpdate: Bool
    
    /// datePickerで選択したDateを格納
    @State var tododate = Date()
    
    /// Todoの登録失敗アラートの表示フラグ
    @State var isAddError = false
    
    /// Todoの更新失敗アラートの表示フラグ
    @State var isUpdateError = false
    
    
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
            Image(systemName: "plus")
                .resizable()
                .rotationEffect(.init(degrees: 45))
        }
        .frame(width: 20, height: 20)
        .accessibility(identifier: "cancelButton")
    }
    
    
    
    
    
    /// ToDo追加ボタン
    var addButton: some View {
        Button(action: {
            
            self.isValidate = self.validateCheck()
            self.toDoModel.todoDate = Format().stringFromDate(date: self.tododate)
            if !self.isValidate {
                
                if !self.isUpdate {
                    let id: String = String(ToDoModel.allFindRealm()!.count + 1)
                    ToDoModel.addRealm(addValue:
                        TableValue(id: id,
                                   title: self.toDoModel.toDoName,
                                   todoDate: self.toDoModel.todoDate,
                                   detail: self.toDoModel.toDo
                    ), date: self.tododate) { error in
                        
                        if let _error = error {
                            print(_error)
                            self.isAddError.toggle()
                            
                        } else {
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }
                    }
                    
                } else {
                    ToDoModel.updateRealm(todoId: Int(self.toDoModel.id)!,
                                          updateValue: TableValue(id: self.toDoModel.id,
                                                                  title: self.toDoModel.toDoName,
                                                                  todoDate: self.toDoModel.todoDate,
                                                                  detail: self.toDoModel.toDo
                    ), date: self.tododate) { error in
                        
                        if let _error = error {
                            print(_error)
                            self.isUpdateError.toggle()
                            
                        } else {
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }
                    }
                }
                
            }
            
        }) {
            Image(systemName: "plus")
                .resizable()
        }
        .frame(width: 20, height: 20)
        .alert(isPresented: $isValidate) {
            Alert(title: Text("入力されていない項目があります"), dismissButton: .default(Text("閉じる")))
        }
        .alert(isPresented: $isAddError) {
            Alert(title: Text("Todoの登録に失敗しました"), dismissButton: .default(Text("閉じる")))
        }
        .alert(isPresented: $isUpdateError) {
            Alert(title: Text("Todoの更新に失敗しました"), dismissButton: .default(Text("閉じる")))
        }
        .accessibility(identifier: "todoAddButton")
    }
    
    
    /// バリデーションチェック
    /// テキストフィールドにテキストが入っていなければtrueを返し、アラートを表示させる
    func validateCheck() -> Bool {
        if toDoModel.toDoName.isEmpty {
            return true
        }
        
        if toDoModel.toDo.isEmpty {
            return true
        }
        return false
    }
    
    
    /// タイトル入力テキストフィールド
    fileprivate func todoNameTextField() -> some View {
        return VStack(alignment: .leading) {
            Text("タイトル")
                .font(.headline)
                .accessibility(identifier: "titlelabel")
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
            Text("詳細")
                .font(.headline)
                .accessibility(identifier: "detailLabel")
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
