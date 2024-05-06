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
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ToDoListView()
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: R.string.notifications.getNotificationStatus()), object: nil)
                    default:
                        break
                    }
                }
        }
    }
}
