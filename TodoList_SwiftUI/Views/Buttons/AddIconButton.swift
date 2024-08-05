//
//  AddButton.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2024/08/04.
//

import SwiftUI

struct AddIconButton: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: "plus")
                .accessibilityLabel(R.string.buttons.add())
        }
        .accessibility(identifier: "addButton")
    }
}

#Preview {
    AddIconButton(action: { })
}
