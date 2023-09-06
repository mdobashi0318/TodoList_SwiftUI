//
//  TagListViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/10.
//

import Foundation


class TagListViewModel: ObservableObject {
    
    @Published var model: [Tag] = []
    
    
    @MainActor
    func fetchAllTag() async {
        model = Tag.findAll()
    }
    
}
