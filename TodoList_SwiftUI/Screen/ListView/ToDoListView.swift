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
    
    @StateObject private var viewModel = ToDoViewModel()
    
    /// Widget、通知をタップして開いた時のTodoを設定する
    @StateObject private var openWidget = OpenTodoManager.shared
    
    /// Todo追加画面のモーダル表示フラグ
    @State private var isShowModle = false
    
    /// 全件削除の確認アラートの表示フラグ
    @State private var isDeleteFlag = false
    
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            TabView(selection: $viewModel.segmentIndex) {
                todoList
                    .tag(SegmentIndex.all)
                
                todoList
                    .tag(SegmentIndex.active)
                
                todoList
                    .tag(SegmentIndex.complete)
                
                todoList
                    .tag(SegmentIndex.expired)
            }
            .tabViewStyle(PageTabViewStyle())
            .navigationBarTitle("ToDoList")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    allDeleteButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
        .sheet(isPresented: $openWidget.isOpneTodo) { openWidgetView }
        }.alert(isPresented: $viewModel.isAlertError) {
            Alert(title: Text(R.string.message.findError()), dismissButton: .default(Text(R.string.labels.close())))
        }
        .accessibility(identifier: "ToDoList")
    }
}




// MARK: - UI

extension ToDoListView {
    
    /// Todoのリストを表示する
    private var todoList: some View {
        List {
            Section(content: {
                if self.viewModel.todoModel.count == 0 {
                    Text(R.string.message.noTodo())
                } else {
                    ForEach(0..<self.viewModel.todoModel.count, id: \.self) { row in
                        NavigationLink(destination:
                                        TodoDetailView(viewModel: TodoDetailViewModel(model: self.viewModel.todoModel[row]))
                                        .onDisappear {
                            withAnimation {
                                viewModel.sinkAllTodoModel(index: $viewModel.segmentIndex.wrappedValue)
                            }
                        }
                        ) {
                            ToDoRow(todoModel: self.viewModel.todoModel[row])
                                .frame(height: 60)
                        }
                    }
                }
            }, header: {
                headerText
                    .font(.headline)
                    .padding()
            })
            
        }
        .listStyle(PlainListStyle())
    }
    
    /// どのカテゴリかを表示するテキスト
    private var headerText: some View {
        switch viewModel.segmentIndex {
        case .all:
            return Text(R.string.labels.all())
        case .active:
            return Text(R.string.labels.active())
        case .complete:
            return Text(R.string.labels.complete())
        case .expired:
            return Text(R.string.labels.expired())
        }
    }
    
    /// ToDoの追加画面に遷移させるボタン
    private var addButton: some View {
        Button(action: {
            self.isShowModle.toggle()
        }) {
            Image(systemName: "plus")
        }
        .sheet(isPresented: $isShowModle) {
            ToDoInputView(viewModel: InputViewModel(), isUpdate: false)
                .onDisappear {
                    withAnimation() {
                        viewModel.sinkAllTodoModel(index: $viewModel.segmentIndex.wrappedValue)
                    }
                }
        }
        .disabled(self.viewModel.isAlertError)
        .accessibility(identifier: "addButton")
        .accessibilityLabel(R.string.accessibilityText.todoAddButton())
    }
    
    
    
    /// 全件削除ボタン
    private var allDeleteButton : some View {
        Button(action: {
            self.isDeleteFlag.toggle()
        }) {
            Image(systemName: "trash")
        }
        .alert(isPresented: self.$isDeleteFlag) {
            Alert(title: Text(R.string.message.allDelete()), primaryButton: .destructive(Text(R.string.labels.delete())) {
                withAnimation() {
                    viewModel.allDeleteTodo()
                }
            }, secondaryButton: .cancel(Text(R.string.labels.cancel())))
        }
        .disabled(self.viewModel.isAlertError)
        .accessibility(identifier: "allDeleteButton")
        .accessibilityLabel(R.string.accessibilityText.allDeleteButton())
    }
    
    /// WidgetでタップしたTodoをモーダルで表示する
    private var openWidgetView: some View {
        return NavigationView {
            TodoDetailView(viewModel: TodoDetailViewModel(model: openWidget.openTodo), isDisplayEllipsisBtn: false)
                .onDisappear { openWidget.isOpneTodo = false }
                .navigationBarTitle(openWidget.openTodo.toDoName)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            openWidget.isOpneTodo = false
                        }) {
                            Image(systemName: "xmark")
                        }
                    }
                }
        }
    }
    
}



// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
