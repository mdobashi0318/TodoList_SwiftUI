//
//  CompletionType.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2025/02/02.
//

import SwiftUI

enum CompletionType {
    case active
    case expired
    case complete
    
    
    var backgroundColor: Color {
        switch self {
        case .active:
                .blue
        case .complete:
                .gray
        case .expired:
                .red
        }
    }
    
}
