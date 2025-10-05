//
//  AddTagTip.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2025/10/05.
//

import SwiftUI
import TipKit

struct AddTagTip: Tip {
    
    @Parameter
    static var addTag: Bool = false
    
    var title: Text {
        Text("addTagTipTitle")
    }
    
    var message: Text? {
        Text("addTagTipMessage")
    }
    
    
    var rules: [Rule] {
        #Rule(Self.$addTag) {
            $0 == true
        }
    }
    
}
