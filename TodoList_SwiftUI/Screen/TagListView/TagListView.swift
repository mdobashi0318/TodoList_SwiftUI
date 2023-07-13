//
//  TagListView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/10.
//

import SwiftUI

struct TagListView: View {
    
    @StateObject var viewModel = TagListViewModel()
    
    @State private var isShowModle = false
    
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.model, id: \.id) { tag in
                    NavigationLink(destination: {
                        EditTagView(viewModel: EditTagViewModel(tag))
                            .onDisappear {
                                Task {
                                    await self.viewModel.fetchAllTag()
                                }
                                
                            }
                    }, label: {
                        TagRow(tag: tag)
                    })
                    
                }
            }
            .navigationTitle("タグリスト")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    addButton
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    closeButton
                }
                
            }
            .task() {
                await self.viewModel.fetchAllTag()
            }
        }
        
    }
    
    private var addButton: some View {
        Button(action: {
            self.isShowModle.toggle()
        }) {
            Image(systemName: "plus")
        }
        .sheet(isPresented: $isShowModle) {
            TagRegistrationView()
                .onDisappear {
                    Task {
                        await self.viewModel.fetchAllTag()
                    }
                    
                }
        }
    }
    
    
    /// 閉じるボタン
    private var closeButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .accessibilityLabel(R.string.labels.close())
        }
        .accessibility(identifier: "closeButton")
    }
    
    
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}
