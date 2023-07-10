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
                    Text(tag.name)
                        .background(Color(cgColor: CGColor.init(red: changeCGFloat(tag.red),
                                                                green: changeCGFloat(tag.green),
                                                                blue: changeCGFloat(tag.blue),
                                                                alpha: changeCGFloat(tag.alpha)
                                                               )))
                }
            }
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
            InputTagView()
                .onDisappear {
                    Task {
                        await self.viewModel.fetchAllTag()
                    }
                    
                }
        }
    }
    
    func changeCGFloat(_ color: String) -> CGFloat  {
        return CGFloat(truncating:NumberFormatter().number(from: color) ?? 0.0)
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}
