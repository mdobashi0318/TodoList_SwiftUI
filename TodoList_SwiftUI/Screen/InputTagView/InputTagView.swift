//
//  InputTagView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/10.
//

import SwiftUI

struct InputTagView: View {
    
    @State var color: CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    @State var name: String = ""
    
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack {
                Section("タグカラー") {
                    TextField("タグ名", text: $name)
                    ColorPicker("タグカラー", selection: $color)
                }
           
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    addButton
                }
            }
        }
    
    }
    
    
    private var addButton: some View {
        Button(action: {
            Tag.add(name: name,color: color)
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "plus")
        }
    }
    
}

struct InputTagView_Previews: PreviewProvider {
    static var previews: some View {
        InputTagView()
    }
}
