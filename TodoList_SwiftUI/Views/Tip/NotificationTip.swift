//
//  NotificationTip.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2025/10/08.
//

import SwiftUI
import TipKit

struct NotificationTip: Tip {
    
    @Parameter
    static var appOpendCount: Int = 0
    
    @Parameter
    static var isNotification: Bool = true
    
    var title: Text {
        Text("NotificationTipTitle")
    }


    var message: Text? {
        Text("NotificationMessage")
    }
    
    
    var rules: [Rule] {
        #Rule(Self.$appOpendCount) {
            $0 >= 3
        }
        
        #Rule(Self.$isNotification) {
            $0 == false
        }
    }
        
}
