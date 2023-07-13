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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.model, id: \.id) { tag in
                    NavigationLink(destination: {
                        EditTagView(id: tag.id, color: tag.color(), name: tag.name)
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
    
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}
