//
//  ContentView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import SwiftUI

struct ToDoListView: View {
    
    // MARK: Properties
    
    @ObservedObject private var toDoviewModel = ToDoViewModel()
    
    @State var isShowModle = false
    
    @State var isDeleteFlag = false
    
    @State var pickerIndex: SegmentIndex = .all
    

    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            List {
                Section() {
                    segmentedPicker()
                }
                
                if self.toDoviewModel.find(index: pickerIndex).count == 0 {
                    Text("ToDoが登録されていません")
                } else {
                    ForEach(0..<self.toDoviewModel.todoModel.count, id: \.self) { row in
                        NavigationLink(destination: TodoDetailView(viewModel: toDoviewModel, toDoModel: self.toDoviewModel.todoModel[row])) {
                            ToDoRow(todoModel: self.toDoviewModel.todoModel[row])
                                .frame(height: 60)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("ToDoList")
            .navigationBarItems(leading: allDeleteButton ,trailing: addButton)
        }
        .accessibility(identifier: "ToDoList")
    }
}




// MARK: - UI

extension ToDoListView {
    
    /// ToDoの追加画面に遷移させるボタン
    var addButton: some View {
        Button(action: {
            self.isShowModle.toggle()
        }) {
            Image(systemName: "plus.circle")
            .resizable()
        }
        .sheet(isPresented: $isShowModle) {
            ToDoInputView(viewModel: .constant(toDoviewModel), toDoModel: .constant(ToDoModel()), isUpdate: false)
        }
        .frame(width: 30, height: 30)
        .accessibility(identifier: "addButton")
    }
    
    
    
    /// 全件削除ボタン
    var allDeleteButton : some View {
        Button(action: {
            self.isDeleteFlag.toggle()
        }) {
            Text("削除")
        }.alert(isPresented: self.$isDeleteFlag) {
            Alert(title: Text("全件削除しますか?"), primaryButton: .destructive(Text("削除")) {
                toDoviewModel.allDeleteTodo()
                }, secondaryButton: .cancel(Text("キャンセル")))
        }
        .accessibility(identifier: "allDeleteButton")
    }
    
    
    
    /// セグメントピッカー
    private func segmentedPicker() -> some View {
        return Picker(selection: $pickerIndex, label: Text("")) {
            Text("全件").tag(SegmentIndex.all)
            Text("アクティブ").tag(SegmentIndex.active)
            Text("期限切れ").tag(SegmentIndex.expired)
        }
        .frame(height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .pickerStyle(SegmentedPickerStyle())
        .padding(.all)
    }
    
}



// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
