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
    @State var isValidate = false
    
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
    }
    
    
    /// ToDo追加ボタン
    var addButton: some View {
        Button(action: {
            
            self.isValidate = self.validateCheck()
            
            if !self.isValidate {
                let id: String = String(ToDoModel.allFindRealm()!.count + 1)
                ToDoModel.addRealm(addValue:
                    TableValue(id: id,
                               title: self.toDoModel.toDoName,
                               todoDate: self.toDoModel.todoDate,
                               detail: self.toDoModel.toDo
                ))
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }) {
            Image(systemName: "plus")
                .resizable()
        }
        .frame(width: 20, height: 20)
        .alert(isPresented: $isValidate) {
            Alert(title: Text("入力されていない項目があります"), dismissButton: .default(Text("閉じる")))
        }
    }
    
    
    /// バリデーションチェック
    /// テキストフィールドにテキストが入っていなければtrueを返し、アラートを表示させる
    func validateCheck() -> Bool {
        if toDoModel.toDoName.isEmpty {
            return true
        }
        
        if toDoModel.todoDate.isEmpty {
            return true
        }
        
        if toDoModel.toDo.isEmpty {
            return true
        }
        return false
    }

    
    
    var body: some View {
        VStack {
            HStack {
                cancelButton
                Spacer()
                addButton
            }
            
                HStack {
                    Text("タイトル")
                    TextField("タイトルを入力してください", text: $toDoModel.toDoName)
                }.frame(height: 50, alignment: .leading)
                
                HStack {
                    Text("期限")
                    TextField("期限を入力してください", text: $toDoModel.todoDate)
                }.frame(height: 50, alignment: .leading)
                
                
                HStack {
                    Text("詳細")
                    TextField("タイトルを入力してください", text: $toDoModel.toDo)
                }.frame(height: 50, alignment: .leading)
                Spacer()
            }
        
        .padding()
        .onDisappear {
            self.toDoModel = ToDoModel()
        }
    }
}

struct ToDoInputView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoInputView(toDoModel: .constant(ToDoModel()))
    }
}
