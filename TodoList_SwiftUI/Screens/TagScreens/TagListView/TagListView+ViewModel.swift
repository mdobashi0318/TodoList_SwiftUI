//
//  TagListViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/10.
//

import Foundation
import Observation

extension TagListView {
    
    @Observable
    class ViewModel {
        
        private(set) var model: [Tag] = []
            
        func fetchAllTag() {
            model = Tag.findAll()
        }
        
    }
}
