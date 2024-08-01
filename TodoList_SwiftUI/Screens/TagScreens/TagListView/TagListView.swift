//
//  TagListView.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/07/10.
//

import SwiftUI
import TipKit

struct TagListView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @State private var isShowModle = false
    
    @Environment(\.presentationMode) private var presentationMode:Binding<PresentationMode>
    
    var body: some View {
        NavigationStack {
            List {
                if #available(iOS 17.0, *) {
                    TipView(TagTip())
                }
                if viewModel.model.isEmpty {
                    Text(R.string.message.noTag())
                } else {
                    ForEach(viewModel.model, id: \.id) { tag in
                        NavigationLink(value: tag) {
                            TagRow(tag: tag)
                        }
                        
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle(R.string.labels.tagList())
            .navigationDestination(for: Tag.self) { tag in
                EditTagView(viewModel: EditTagView.ViewModel(tag))
                    .onDisappear {
                        Task {
                            await self.viewModel.fetchAllTag()
                        }
                        
                    }
            }
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
            AddTagView()
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
