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
                .foregroundColor(Color(cgColor: CGColor.init(red: changeCGFloat(tag.red),
                                                             green: changeCGFloat(tag.green),
                                                             blue: changeCGFloat(tag.blue),
                                                             alpha: changeCGFloat(tag.alpha)
                                                            )))
                .frame(width: 20, height: 20)
            Text(tag.name)
            
        }
    }
    
    private func changeCGFloat(_ color: String) -> CGFloat  {
        return CGFloat(truncating:NumberFormatter().number(from: color) ?? 0.0)
    }
}

struct TagRow_Previews: PreviewProvider {
    static var previews: some View {
        TagRow(tag: Tag())
    }
}
