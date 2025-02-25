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
    
    
    var title: String {
        switch self {
        case .active:
            R.string.labels.active()
        case .complete:
            R.string.labels.complete()
        case .expired:
            R.string.labels.expired()
        }
    }
    
    
    static func isType(flag: CompletionFlag, date: String) -> CompletionType {
        if flag == CompletionFlag.completion {
            CompletionType.complete
        } else {
            Format.dateFromString(string: date) ?? Date() > Format.dateFormat() ? CompletionType.active : CompletionType.expired
        }
    }
    
}
