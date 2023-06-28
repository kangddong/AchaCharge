//
//  ProgressBar.swift
//  Controllers
//
//  Created by dongyeongkang on 2023/06/28.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float
    @State var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 11.0)
                .opacity(0.3)
                .foregroundColor(Color.green)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(self.progress))
                .stroke(style: StrokeStyle(lineWidth: 11.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear(duration: 2.0), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
    }
}
