//
//  EditTagView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/11.
//

import SwiftUI

struct EditTagView: View {
    
    @StateObject var viewModel: EditTagViewModel
    
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    /// Alertの表示フラグ
    @State private var isShowAlert = false
    
    @State private var errorMessage = ""
    
    @State private var deleteConfilmFlag = false

    var body: some View {
        TagView(name: $viewModel.name, color: $viewModel.color)
            .navigationTitle("タグ編集")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    deleteButton
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
                try viewModel.update()
                self.presentationMode.wrappedValue.dismiss()
            } catch(let error as TagModelError) {
                self.errorMessage = error.message
                isShowAlert = true
            } catch {
                self.errorMessage = "エラーが発生しました"
                isShowAlert = true
            }
        }) {
            Text("Done")
        }
    }
    
    
    private var deleteButton: some View {
        Button(action: {
            deleteConfilmFlag.toggle()
        }) {
            Image(systemName: "trash")
        }
        .alert(isPresented: $deleteConfilmFlag) {
            return Alert(title: Text("このラベルを削除しますか?"),
                         primaryButton: .destructive(Text("削除"), action: {
                do {
                    try viewModel.delete()
                    self.presentationMode.wrappedValue.dismiss()
                } catch(let error as TagModelError) {
                    self.errorMessage = error.message
                    isShowAlert = true
                } catch {
                    self.errorMessage = "エラーが発生しました"
                    isShowAlert = true
                }
            }), secondaryButton: .cancel(Text(R.string.labels.cancel())))
        }
    }
    
    
}
