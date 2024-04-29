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
    
    /// 通知が許可されているか
    @Published var isNotification = false
    
    private let notificationPublisher = NotificationCenter.default.publisher(for: Notification.Name(rawValue: R.string.notifications.getNotificationStatus()))
        .sink(receiveValue: { _ in
            Task {
                await shared.getNotificationStatus()
            }
        })
    
    
    /// 設定画面を開く
    ///
    /// - iOS16以上: 設定アプリの通知設定画面に遷移する
    /// - iOS15以下: 設定アプリのアプリ設定画面に遷移する
    @MainActor
    func openSettingsURL() {
        Task {
            if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                /// シミュレータに「設定」>「通知」>「アプリ」の動線がないので実機でしか通知設定に遷移しない。
                let _ = await UIApplication.shared.open(url)
            }
        }
    }
    
    
    /// 通知の許諾状態を取得する
    @MainActor
    private func getNotificationStatus() async {
        isNotification = await NotificationManager().getNotificationStatus()
    }
    
    
}
