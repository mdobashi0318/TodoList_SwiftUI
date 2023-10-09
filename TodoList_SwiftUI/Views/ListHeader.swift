//
//  ListHeader.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/10/09.
//

import SwiftUI

struct ListHeader: View {
    
    @Binding var segmentIndex: SegmentIndex
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 1) {
                ForEach(0..<SegmentIndex.allCases.count, id: \.self) { index in
                    Button(action: {
                        guard let selectIndex = SegmentIndex(rawValue: index) else { return }
                        segmentIndex = selectIndex
                    }, label: {
                        Text(buttonText(index))
                    })
                    .frame(minWidth: UIScreen.main.bounds.width / CGFloat(SegmentIndex.allCases.count) , minHeight: 40)
                    // TODO: 色を変更
                    .background(segmentIndex == SegmentIndex(rawValue: index) ? Color(uiColor: UIColor.systemBackground) : Color(uiColor: UIColor.systemGray))
                }
            }
        }
    }
    
    
    
    private func buttonText(_ index: Int) -> String {
        switch index {
        case SegmentIndex.all.rawValue:
            R.string.labels.all()
        case SegmentIndex.active.rawValue:
            R.string.labels.active()
        case SegmentIndex.expired.rawValue:
            R.string.labels.expired()
        case SegmentIndex.complete.rawValue:
            R.string.labels.complete()
        default:
            ""
        }
        
        
    }
}

#Preview {
    ListHeader(segmentIndex: .constant(SegmentIndex.all))
}
