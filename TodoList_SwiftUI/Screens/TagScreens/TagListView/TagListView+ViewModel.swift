//
//  TagListViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/10.
//

import Foundation

extension TagListView {
    
    class ViewModel: ObservableObject {
        
        @Published var model: [Tag] = []
            
        func fetchAllTag() {
            model = Tag.findAll()
        }
        
    }
}
