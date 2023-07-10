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
    
    /// Alertの表示フラグ
    @State private var isShowAlert = false
    
    
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("タグ") {
                    TextField("タグ名", text: $name)
                    ColorPicker("タグカラー", selection: $color)
                }
           
            }
            .navigationTitle("タグ作成")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .alert(isPresented: $isShowAlert) {
                return Alert(title: Text(errorMessage), dismissButton: .default(Text(R.string.labels.close())))
            }
        }
    
    }
    
    
    private var addButton: some View {
        Button(action: {
            do {
                if name.isEmpty {
                    self.errorMessage = "タグ名を入力してください"
                    isShowAlert = true
                    return
                }
                
                try Tag.add(name: name,color: color)
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                self.errorMessage = "タグの追加に失敗しました"
                isShowAlert = true
            }
            
            
            
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
