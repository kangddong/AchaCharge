//
//  ProgressBar.swift
//  Controllers
//
//  Created by dongyeongkang on 2023/06/28.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float
    
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
        }
    }
}
