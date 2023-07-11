//
//  TagRow.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/11.
//

import SwiftUI

struct TagRow: View {
    
    let tag: Tag
    
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(Color(cgColor: tag.color()))
                .frame(width: 20, height: 20)
            Text(tag.name)
            
        }
    }
    

}

struct TagRow_Previews: PreviewProvider {
    static var previews: some View {
        TagRow(tag: Tag())
    }
}
