//
//  WrapView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 4/8/26.
//

import SwiftUI

struct WrapView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    
    var items: Data
    var content: (Data.Element) -> Content
    
    var body: some View {
        FlexibleView(
            data: items,
            spacing: 8,
            alignment: .leading,
            content: content
        )
    }
}

// MARK: - Flexible Layout Engine
struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    
    @State private var totalHeight = CGFloat.zero
    
    var body: some View {
        GeometryReader { geometry in
            generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
            ForEach(Array(data), id: \.self) { item in
                content(item)
                    .padding(.horizontal, 4)
                    .alignmentGuide(.leading) { d in
                        if abs(width - d.width) > geometry.size.width {
                            width = 0
                            height -= d.height + spacing
                        }
                        let result = width
                        width -= d.width + spacing
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geo -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geo.size.height
            }
            return Color.clear
        }
    }
}
