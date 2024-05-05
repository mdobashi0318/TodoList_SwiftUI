//
//  ToDoListApp.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2024/05/05.
//

import SwiftUI

@main
struct ToDoListApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegates
    
    var body: some Scene {
        WindowGroup {
            ToDoListView()
        }
    }
}
