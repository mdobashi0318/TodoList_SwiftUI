//
//  TagView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/11.
//

import SwiftUI

struct TagView: View {
    
    @Binding var name: String
    
    @Binding var color: CGColor
    
    
    var body: some View {
        Form {
            Section("タグ") {
                TextField("タグ名", text: $name)
                ColorPicker("タグカラー", selection: $color)
            }
       
        }
    }
}


