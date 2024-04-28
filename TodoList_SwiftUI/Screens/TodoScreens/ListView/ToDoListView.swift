//
//  ContentView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import SwiftUI
import TipKit

struct ToDoListView: View {
    
    // MARK: Properties
    
    @StateObject private var viewModel = ToDoViewModel()
    
    /// Widget、通知をタップして開いた時のTodoを設定する
    @StateObject private var openWidget = OpenTodoManager.shared
    
    @StateObject private var setting = SettingManager.shared
    
    /// Todo追加画面のモーダル表示フラグ
    @State private var isShowModle = false
    
    /// 全件削除の確認アラートの表示フラグ
    @State private var isDeleteFlag = false
    
    /// Tagリスト画面のモーダル表示フラグ
    @State private var isShowTagModle = false
    
    // MARK: Body
    
    var body: some View {
        NavigationStack {
            VStack {
                ListHeader(segmentIndex: self.$viewModel.segmentIndex)
                TabView(selection: $viewModel.segmentIndex) {
                    todoList
                        .tag(SegmentIndex.all)
                    
                    todoList
                        .tag(SegmentIndex.active)
                    
                    todoList
                        .tag(SegmentIndex.expired)
                    
                    todoList
                        .tag(SegmentIndex.complete)
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .task(id: viewModel.segmentIndex) {
                    await viewModel.fetchAllTodoModel()
                }
                .task {
                    if #available(iOS 17.0, *) {
                        try? Tips.configure([
                                     .displayFrequency(.immediate),
                                     .datastoreLocation(.applicationDefault)
                                 ])
                    }
                }
                .task(id: viewModel.searchTagId) {
                    await viewModel.fetchAllTodoModel()
                }
            }
            .navigationTitle("ToDoList")
            .navigationDestination(for: ToDoModel.self) { model in
                TodoDetailView(viewModel: TodoDetailViewModel(model: model))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    allDeleteButton
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    tagButton
                    notificationButton
                    if #available(iOS 17.0, *) {
                        addButton
                            .popoverTip(AddTodoTip())
                    } else {
                        addButton
                    }
                }
            }
            .sheet(isPresented: $openWidget.isOpneTodo) { openWidgetView }
        }
        .alert(isPresented: $viewModel.isAlertError) {
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
                Picker(R.string.labels.filterByTag(), selection: $viewModel.searchTagId) {
                    ForEach(viewModel.tagModel, id: \.id) { tag in
                        Text(tag.name)
                    }
                }
                if self.viewModel.todoModel.count == 0 {
                    Text(R.string.message.noTodo())
                } else {
                    ForEach(0..<self.viewModel.todoModel.count, id: \.self) { row in
                        NavigationLink(value: self.viewModel.todoModel[row]) {
                            ToDoRow(todoModel: self.$viewModel.todoModel[row])
                                .frame(height: 60)
                        }
                    }
                }
            })
        }
        .listStyle(InsetListStyle())
    }
    
    /// どのカテゴリかを表示するテキスト
    @ViewBuilder
    private var headerText: some View {
        switch viewModel.segmentIndex {
        case .all:
             Text(R.string.labels.all())
        case .active:
             Text(R.string.labels.active())
        case .complete:
             Text(R.string.labels.complete())
        case .expired:
             Text(R.string.labels.expired())
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
                    Task {
                        await viewModel.fetchAllTodoModel()
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
                viewModel.allDeleteTodo()
            }, secondaryButton: .cancel(Text(R.string.labels.cancel())))
        }
        .disabled(self.viewModel.isAlertError)
        .accessibility(identifier: "allDeleteButton")
        .accessibilityLabel(R.string.accessibilityText.allDeleteButton())
    }
    
    
    /// 通知設定ボタン
    private var notificationButton: some View {
        Button(action: {
            setting.openSettingsURL()
        }) {
            Image(systemName: setting.isNotification ? "bell" : "bell.slash")
        }
    }
    
    /// タグリスト画面に遷移させるボタン
    private var tagButton: some View {
        Button(action: {
            self.isShowTagModle.toggle()
        }) {
            Image(systemName: "tag")
        }
        .fullScreenCover(isPresented: $isShowTagModle) {
            TagListView()
                .onDisappear {
                    Task {
                        await viewModel.fetchAllTodoModel()
                        viewModel.fetchAllTag()
                    }
                }
        }
        .accessibility(identifier: "tagButton")
    }
    
    /// WidgetでタップしたTodoをモーダルで表示する
    private var openWidgetView: some View {
        return NavigationStack {
            TodoDetailView(viewModel: TodoDetailViewModel(model: openWidget.openTodo), isDisplayEllipsisBtn: false)
                .onDisappear { openWidget.isOpneTodo = false }
                .navigationTitle(openWidget.openTodo.toDoName)
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
