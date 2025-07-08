//
//  PadView.swift
//  peace piece
//
//  Created by Levi Funk on 2/7/25.
//

import Foundation
import SwiftUI

struct PadView: View {
    @ObservedObject var viewModel: PadViewModel
    
    var body: some View {
        Rectangle()
            .fill(colorForState())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { _ in
                        viewModel.toggleState()
                        print("Cell with ID \(viewModel.id) dragged")
                    }
            )
            .overlay(
                Text("\(viewModel.id)")
                    .foregroundColor(.white)
                    .font(.caption)
            )
            .cornerRadius(8)
    }
    
    private func colorForState() -> Color {
        switch viewModel.state {
        case .initial: return Color.gray
        case .cued: return Color.orange
        case .playing: return Color.green
        }
    }
}
