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
    
    @StateObject private var toDoviewModel = ToDoViewModel()
    
    @StateObject private var openWidget = OpenTodoManager.shared
    
    @State private var isShowModle = false
    
    @State private var isDeleteFlag = false
    
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            List {
                segmenteSection
                if self.toDoviewModel.todoModel.count == 0 {
                    Text(R.string.message.noTodo())
                } else {
                    ForEach(0..<self.toDoviewModel.todoModel.count, id: \.self) { row in
                        NavigationLink(destination:
                                        TodoDetailView(viewModel: TodoDetailViewModel(model: self.toDoviewModel.todoModel[row]))
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
            Alert(title: Text(R.string.message.findError()), dismissButton: .default(Text(R.string.labels.close())))
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
        .accessibilityLabel(R.string.accessibilityText.todoAddButton())
    }
    
    
    
    /// 全件削除ボタン
    var allDeleteButton : some View {
        Button(action: {
            self.isDeleteFlag.toggle()
        }) {
            Image(systemName: "trash")
        }
        .alert(isPresented: self.$isDeleteFlag) {
            Alert(title: Text(R.string.message.allDelete()), primaryButton: .destructive(Text(R.string.labels.delete())) {
                toDoviewModel.allDeleteTodo()
                }, secondaryButton: .cancel(Text(R.string.labels.cancel())))
        }
        .disabled(self.toDoviewModel.isAlertError)
        .accessibility(identifier: "allDeleteButton")
        .accessibilityLabel(R.string.accessibilityText.allDeleteButton())
    }
    
    
    
    /// セグメントピッカーセクション
    private var segmenteSection: some View {
        return Section() {
            Picker(selection: $toDoviewModel.segmentIndex, label: Text("")) {
                Text(R.string.labels.all()).tag(SegmentIndex.all)
                    .accessibilityLabel(R.string.accessibilityText.all())
                Text(R.string.labels.active()).tag(SegmentIndex.active)
                    .accessibilityLabel(R.string.accessibilityText.active())
                Text(R.string.labels.complete()).tag(SegmentIndex.complete)
                    .accessibilityLabel(R.string.accessibilityText.complete())
                Text(R.string.labels.expired()).tag(SegmentIndex.expired)
                    .accessibilityLabel(R.string.accessibilityText.expired())
            }
            .frame(height: 30, alignment: .center)
            .pickerStyle(SegmentedPickerStyle())
            .padding(.all)
        }
    }
    
    
    /// WidgetでタップしたTodoをモーダルで表示する
    private var openWidgetView: some View {
        return NavigationView {
            TodoDetailView(viewModel: TodoDetailViewModel(model: openWidget.openTodo))
                .onDisappear { openWidget.isOpneTodo = false }
                .navigationBarTitle(openWidget.openTodo.toDoName)
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
