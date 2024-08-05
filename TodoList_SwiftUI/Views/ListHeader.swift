//
//  ListHeader.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/10/09.
//

import SwiftUI

struct ListHeader: View {
    
    @Binding private var segmentIndex: SegmentIndex
    
    /// バーのX座標
    @State private var positionX : CGFloat
    
    /// バーの位置調整するための値
    private let constPositionX: CGFloat = -1.5
    
    init(segmentIndex: Binding<SegmentIndex>) {
        self._segmentIndex = segmentIndex
        self.positionX = UIScreen.main.bounds.width * constPositionX
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            VStack {
                ZStack(alignment: .bottom) {
                    tabs
                    bar
                }
                Divider()
            }
            
        }
        .task(id: segmentIndex) {
            moveBar(segmentIndex.rawValue)
        }
    }
    
    
    
    private var tabs: some View {
        HStack(spacing: 1) {
            ForEach(0..<SegmentIndex.allCases.count, id: \.self) { index in
                Button(action: {
                    guard let selectIndex = SegmentIndex(rawValue: index) else { return }
                    segmentIndex = selectIndex
                }, label: {
                    Text(buttonText(index))
                })
                .frame(minWidth: UIScreen.main.bounds.width / CGFloat(SegmentIndex.allCases.count) , minHeight: 40)
            }
        }
    }
    
    
    private var bar: some View {
        Rectangle()
            .cornerRadius(18)
            .frame(width: UIScreen.main.bounds.width / CGFloat(SegmentIndex.allCases.count) / 1.5, height: 4)
            .foregroundColor(.blue)
            .offset(x: positionX, y: 0)
    }
    
    
    private func moveBar(_ index: Int) {
        var addPositionX: CGFloat = constPositionX
        withAnimation(.default) {
            addPositionX += CGFloat(index)
            positionX = UIScreen.main.bounds.width / CGFloat(SegmentIndex.allCases.count) * addPositionX
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
    Group {
        ListHeader(segmentIndex: .constant(.all))
        ListHeader(segmentIndex: .constant(.active))
        ListHeader(segmentIndex: .constant(.expired))
        ListHeader(segmentIndex: .constant(.complete))
    }
}
