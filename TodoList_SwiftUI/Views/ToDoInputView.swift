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
    @State var isShowModle: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    
    /// キャンセルボタン
    var cancelButton: some View {
        Button(action: {
            self.isShowModle.toggle()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("×")
        }
        .frame(width: 50, height: 50)
    }
    
    
    /// ToDo追加ボタン
    var addButton: some View {
        Button(action: {
            let id: String = String(ToDoModel.allFindRealm()!.count + 1)
            
            self.isShowModle.toggle()
            self.presentationMode.wrappedValue.dismiss()
            ToDoModel.addRealm(addValue:
                TableValue(id: id,
                           title: self.toDoModel.toDoName,
                           todoDate: self.toDoModel.todoDate,
                           detail: self.toDoModel.toDo
            ))
        }) {
            Image(systemName: "plus.circle")
        }.frame(width: 50, height: 50)
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
