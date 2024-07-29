//
//  InputTagView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/10.
//

import SwiftUI

/// タグ登録画面
struct AddTagView: View {
    
    @State var color: CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    @State var name: String = ""
    
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    /// Alertの表示フラグ
    @State private var isShowAlert = false
    
    
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            TagView(name: $name, color: $color, disabledFlag: .constant(false))
                .navigationTitle(R.string.labels.addTag())
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
                if name.isEmpty || name.isSpace() {
                    self.errorMessage = R.string.message.inputTag()
                    isShowAlert = true
                    return
                }
                
                try Tag.add(name: name,color: color)
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                self.errorMessage = R.string.message.tagAddError()
                isShowAlert = true
            }
            
            
            
        }) {
            Image(systemName: "plus")
        }
    }
    
}

struct InputTagView_Previews: PreviewProvider {
    static var previews: some View {
        AddTagView()
    }
}
