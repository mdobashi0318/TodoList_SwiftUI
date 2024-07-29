//
//  TagView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/11.
//

import SwiftUI


/// タグの詳細を表示するView
struct TagView: View {
    
    @Binding var name: String
    
    @Binding var color: CGColor
    
    @Binding var disabledFlag: Bool
    
    var body: some View {
        Form {
            Section(R.string.labels.tag()) {
                TextField(R.string.labels.tagName(), text: $name)
                    .disabled(disabledFlag)
                ColorPicker(R.string.labels.tagColor(), selection: $color)
                    .disabled(disabledFlag)
            }
       
        }
    }
}





struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(name: .constant("name"), color: .constant(.init(red: 10, green: 10, blue: 10, alpha: 1)), disabledFlag: .constant(false))
    }
}
