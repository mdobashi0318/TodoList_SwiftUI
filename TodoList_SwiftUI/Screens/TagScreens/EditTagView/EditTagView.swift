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
    
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    /// Alertの表示フラグ
    @State private var isShowAlert = false
    
    @State private var errorMessage = ""
    
    @State private var deleteConfilmFlag = false
    
    @State private var disabledFlag = true

    var body: some View {
        TagView(name: $viewModel.name, color: $viewModel.color, disabledFlag: $disabledFlag)
            .navigationTitle(disabledFlag ? R.string.labels.tagDetails() : R.string.labels.editTag())
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    navigationBarTrailingButton()
                }
            }
            .alert(isPresented: $isShowAlert) {
                return Alert(title: Text(errorMessage), dismissButton: .default(Text(R.string.buttons.close)))
            }
    }
    
    
    @ViewBuilder
    private func navigationBarTrailingButton() -> some View {
        if disabledFlag {
            deleteButton
            editButton
        } else {
            cancelButton
            doneButton
        }
    }
    
    private var editButton: some View {
        Button(action: {
            disabledFlag.toggle()
        }) {
            Text(R.string.buttons.edit)
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            do {
                try viewModel.update()
                self.presentationMode.wrappedValue.dismiss()
            } catch(let error as TagModelError) {
                self.errorMessage = error.message
                isShowAlert = true
            } catch {
                self.errorMessage = R.string.message.tagEditError()
                isShowAlert = true
            }
        }) {
            Text(R.string.buttons.done)
        }
    }
    
    
    private var deleteButton: some View {
        Button(action: {
            deleteConfilmFlag.toggle()
        }) {
            Image(systemName: "trash")
        }
        .alert(isPresented: $deleteConfilmFlag) {
            return Alert(title: Text(R.string.message.deleteTag()),
                         primaryButton: .destructive(Text(R.string.buttons.delete()), action: {
                do {
                    try viewModel.delete()
                    self.presentationMode.wrappedValue.dismiss()
                } catch(let error as TagModelError) {
                    self.errorMessage = error.message
                    isShowAlert = true
                } catch {
                    self.errorMessage = R.string.message.tagDeleteError()
                    isShowAlert = true
                }
            }), secondaryButton: .cancel(Text(R.string.buttons.cancel())))
        }
    }
    
    
    
    private var cancelButton: some View {
        Button(action: {
            disabledFlag.toggle()
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
