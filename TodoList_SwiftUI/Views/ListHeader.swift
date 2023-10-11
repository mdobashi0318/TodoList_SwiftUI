//
//  ListHeader.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2023/10/09.
//

import SwiftUI

struct ListHeader: View {
    
    @Binding var segmentIndex: SegmentIndex
    
    @State var positionX : CGFloat = -UIScreen.main.bounds.width /  2.6
    
    var body: some View {
        ScrollView(.horizontal) {
            ZStack(alignment: .bottom) {
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
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width / CGFloat(SegmentIndex.allCases.count) / 1.5, height: 5)
                    .foregroundColor(.red)
                    .offset(x: positionX, y: 0)
                
            }
        }
        .task(id: segmentIndex) {
            selectedBar(segmentIndex.rawValue)
        }
        
    }
    
    private func selectedBar(_ index: Int) {
        withAnimation(.default) {
            // TODO: バーの位置を調整
            switch index {
            case 0:
                positionX = -UIScreen.main.bounds.width /  2.6
            case 1:
                positionX = -UIScreen.main.bounds.width /  8.1
            case 2:
                positionX = UIScreen.main.bounds.width /  8.1
            case 3:
                positionX = UIScreen.main.bounds.width /  2.7
            default:
                break
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
