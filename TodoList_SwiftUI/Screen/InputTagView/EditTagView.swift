//
//  EditTagView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/11.
//

import SwiftUI

struct EditTagView: View {
    
    let id: String
    
    @State var color: CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    @State var name: String = ""
    
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    /// Alertの表示フラグ
    @State private var isShowAlert = false
    
    
    @State private var errorMessage = ""
    
    var body: some View {
        TagView(name: $name, color: $color)
            .navigationTitle("タグ編集")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    editButton
                }
            }
            .alert(isPresented: $isShowAlert) {
                return Alert(title: Text(errorMessage), dismissButton: .default(Text(R.string.labels.close())))
            }
    }
    
    
    private var editButton: some View {
        Button(action: {
            do {
                if name.isEmpty {
                    self.errorMessage = "タグ名を入力してください"
                    isShowAlert = true
                    return
                }
                
                try Tag.update(id: id, name: name,color: color)
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                self.errorMessage = "タグの更新に失敗しました"
                isShowAlert = true
            }
        }) {
            Text("Done")
        }
    }
    
    
}
