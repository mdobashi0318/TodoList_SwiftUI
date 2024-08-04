//
//  EditTagView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/11.
//

import SwiftUI

/// タグ編集画面
struct EditTagView: View {
    
    @StateObject var viewModel: ViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    /// 削除確認フラグ
    @State private var isDeleteConfilm = false
    /// タグの編集不可フラグ
    @State private var isEditDisabled = true
    
    var body: some View {
        TagView(name: $viewModel.name, color: $viewModel.color, disabledFlag: $isEditDisabled)
            .navigationTitle(isEditDisabled ? R.string.labels.tagDetails() : R.string.labels.editTag())
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    navigationBarTrailingButton()
                }
            }
            .alert(isPresented: $viewModel.isShowAlert) {
                return Alert(title: Text(viewModel.errorMessage), dismissButton: .default(Text(R.string.buttons.close)))
            }
    }
    
    
    @ViewBuilder
    private func navigationBarTrailingButton() -> some View {
        if isEditDisabled {
            deleteButton
            editButton
        } else {
            cancelButton
            doneButton
        }
    }
    
    private var editButton: some View {
        Button(action: {
            isEditDisabled.toggle()
        }) {
            Text(R.string.buttons.edit)
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            viewModel.update()
            if !viewModel.isShowAlert {
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text(R.string.buttons.done)
        }
    }
    
    
    private var deleteButton: some View {
        DeleteIconButton {
            isDeleteConfilm.toggle()
        }
        .alert(isPresented: $isDeleteConfilm) {
            return Alert(title: Text(R.string.message.deleteTag()),
                         primaryButton: .destructive(Text(R.string.buttons.delete()), action: {
                viewModel.delete()
                if !viewModel.isShowAlert {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }), secondaryButton: .cancel(Text(R.string.buttons.cancel())))
        }
    }
    
    
    
    private var cancelButton: some View {
        Button(action: {
            isEditDisabled.toggle()
            viewModel.rollback()
        }) {
            Text(R.string.buttons.cancel)
        }
    }
    
}




struct EditTagView_Previews: PreviewProvider {
    
    static func dummy() -> Tag {
        let tag = Tag()
        tag.name = "name"
        tag.blue = "10"
        tag.green = "10"
        tag.red = "10"
        tag.alpha = "10"
        
        return tag
    }
    
    static var previews: some View {
        EditTagView(viewModel: EditTagView.ViewModel(dummy()))
    }
}
