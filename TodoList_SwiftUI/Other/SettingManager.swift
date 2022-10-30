//
//  SettingManager.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2022/10/29.
//

import Foundation
import UIKit


class SettingManager: ObservableObject {
    
    static let shared = SettingManager()
    
    @Published var isNotification = false
    
    private let notificationPublisher = NotificationCenter.default.publisher(for: Notification.Name(rawValue: R.string.notifications.getNotificationStatus()))
        .sink(receiveValue: { _ in
            Task {
                await shared.getNotificationStatus()
            }
        })
    
    
    @MainActor
    func openSettingsURL() {
        if #available(iOS 16.0, *) {
            Task {
                if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                    /// シミュレータには「設定」>「通知」>「アプリ」の動線がないので実機でしか通知設定に遷移しない。
                    let _ = await UIApplication.shared.open(url)
                }
            }
        } else {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    
    
    @MainActor
    func getNotificationStatus() async {
        isNotification = await NotificationManager().getNotificationStatus()
    }
    
    
}
