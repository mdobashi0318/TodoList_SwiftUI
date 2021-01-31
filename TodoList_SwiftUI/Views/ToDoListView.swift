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
    
    @ObservedObject private var openWidget = WidgetOpenManager.shared
    
    @State var isShowModle = false
    
    @State var isDeleteFlag = false
    
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            List {
                segmenteSection
                if self.toDoviewModel.todoModel.count == 0 {
                    Text("ToDoが登録されていません")
                } else {
                    ForEach(0..<self.toDoviewModel.todoModel.count, id: \.self) { row in
                        NavigationLink(destination:
                                        TodoDetailView(toDoModel: self.$toDoviewModel.todoModel[row])
                                        .onDisappear { self.toDoviewModel.sinkAllTodoModel(index: $toDoviewModel.segmentIndex.wrappedValue) }
                        ) {
                            ToDoRow(todoModel: self.toDoviewModel.todoModel[row])
                                .frame(height: 60)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("ToDoList")
            .navigationBarItems(leading: allDeleteButton ,trailing: addButton)
            .sheet(isPresented: $openWidget.isOpneTodo) { openWidgetView }
        }.alert(isPresented: $toDoviewModel.isAlertError) {
            Alert(title: Text("Todoの取得に失敗しました"), dismissButton: .default(Text("閉じる")))
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
            Image(systemName: "plus")
        }
        .sheet(isPresented: $isShowModle) {
            ToDoInputView(inputViewModel: InputViewModel(), isUpdate: false)
                .onDisappear {
                    toDoviewModel.sinkAllTodoModel(index: $toDoviewModel.segmentIndex.wrappedValue)
                }
        }
        .disabled(self.toDoviewModel.isAlertError)
        .accessibility(identifier: "addButton")
    }
    
    
    
    /// 全件削除ボタン
    var allDeleteButton : some View {
        Button(action: {
            self.isDeleteFlag.toggle()
        }) {
            Image(systemName: "trash")
        }
        .alert(isPresented: self.$isDeleteFlag) {
            Alert(title: Text("全件削除しますか?"), primaryButton: .destructive(Text("削除")) {
                toDoviewModel.allDeleteTodo()
                }, secondaryButton: .cancel(Text("キャンセル")))
        }
        .disabled(self.toDoviewModel.isAlertError)
        .accessibility(identifier: "allDeleteButton")
    }
    
    
    
    /// セグメントピッカーセクション
    private var segmenteSection: some View {
        return Section() {
            Picker(selection: $toDoviewModel.segmentIndex, label: Text("")) {
                Text("全件").tag(SegmentIndex.all)
                Text("アクティブ").tag(SegmentIndex.active)
                Text(R.string.labels.complete()).tag(SegmentIndex.complete)
                Text("期限切れ").tag(SegmentIndex.expired)
            }
            .frame(height: 30, alignment: .center)
            .pickerStyle(SegmentedPickerStyle())
            .padding(.all)
        }
    }
    
    
    /// WidgetでタップしたTodoをモーダルで表示する
    private var openWidgetView: some View {
        return NavigationView {
            TodoDetailView(toDoModel: .constant(openWidget.nextTodo))
                .onDisappear { openWidget.isOpneTodo = false }
                .navigationBarTitle(openWidget.nextTodo.toDoName)
                .navigationBarItems(leading: Button(action: {
                    openWidget.isOpneTodo = false
                }, label: {
                    Image(systemName: "xmark")
                }), trailing: Button(""){})
        }
    }
    
}



// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
