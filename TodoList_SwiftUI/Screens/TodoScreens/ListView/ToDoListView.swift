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
    
    @StateObject private var viewModel = ViewModel()
    /// Widget、通知をタップして開いた時のTodoを設定する
    @StateObject private var openWidget = OpenTodoManager.shared
    
    @StateObject private var setting = SettingManager.shared
    
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
                    withAnimation {
                        viewModel.fetchAllTodoModel()
                    }
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
                    withAnimation {
                        viewModel.fetchAllTodoModel()
                    }
                }
            }
            .navigationTitle("ToDoList")
            .navigationDestination(for: ToDoModel.self) { model in
                TodoDetailView(viewModel: TodoDetailView.ViewModel(createTime: model.createTime ?? ""))
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
            Alert(title: Text(R.string.message.findError()), dismissButton: .default(Text(R.string.buttons.close())))
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
                if viewModel.tagModel.isNotEmpty {
                    Picker(R.string.labels.filterByTag(), selection: $viewModel.searchTagId) {
                        ForEach(viewModel.tagModel, id: \.id) { tag in
                            Text(tag.name)
                        }
                    }
                }
                if self.viewModel.todoModel.count == 0 {
                    Text(R.string.message.noTodo())
                } else {
                    ForEach(0..<self.viewModel.todoModel.count, id: \.self) { row in
                        NavigationLink(value: self.viewModel.todoModel[row]) {
                            ToDoRow(todoModel: viewModel.todoModel[row])
                        }
                    }
                }
            })
        }
        .listStyle(.inset)
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
        AddIconButton {
            viewModel.isShowModle.toggle()
        }
        .sheet(isPresented: $viewModel.isShowModle) {
            ToDoInputView(viewModel: ToDoInputView.ViewModel(), isUpdate: false)
                .onDisappear {
                    withAnimation {
                        viewModel.fetchAllTodoModel()
                    }
                }
        }
        .disabled(self.viewModel.isAlertError)
        .accessibilityLabel(R.string.accessibilityText.todoAddButton())
    }
    
    
    
    /// 全件削除ボタン
    private var allDeleteButton : some View {
        
        DeleteIconButton {
            viewModel.isDeleteFlag.toggle()
        }
        .alert(isPresented: $viewModel.isDeleteFlag) {
            Alert(title: Text(R.string.message.allDelete()), primaryButton: .destructive(Text(R.string.buttons.delete)) {
                Task {
                    await viewModel.allDeleteTodo()
                }
                withAnimation {
                    viewModel.todoModelDelete()
                }
            }, secondaryButton: .cancel(Text(R.string.buttons.cancel)))
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
            viewModel.isShowTagModle.toggle()
        }) {
            Image(systemName: "tag")
        }
        .fullScreenCover(isPresented: $viewModel.isShowTagModle) {
            TagListView()
                .onDisappear {
                        viewModel.fetchAllTodoModel()
                        viewModel.fetchAllTag()
                }
        }
        .accessibility(identifier: "tagButton")
    }
    
    /// WidgetでタップしたTodoをモーダルで表示する
    private var openWidgetView: some View {
        return NavigationStack {
            TodoDetailView(viewModel: TodoDetailView.ViewModel(createTime: openWidget.openTodo.createTime ?? ""), isDisplayEllipsisBtn: false)
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
