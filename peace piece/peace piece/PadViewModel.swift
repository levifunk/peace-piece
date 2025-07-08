//
//  PadViewModel.swift
//  peace piece
//
//  Created by Levi Funk on 2/7/25.
//

import Foundation

enum PadState {
    case initial
    case cued
    case playing
}

class PadViewModel: ObservableObject, Identifiable {
    let id: Int
    let column: Int
    @Published var state: PadState = .initial {
        didSet {
            onStateChange?(state)
        }
    }
    
    var onStateChange: ((PadState) -> Void)?
    
    init(id: Int, column: Int) {
        self.id = id
        self.column = column
    }
    
    func toggleState() {
        state = (state == .initial) ? .cued : .initial
    }
    
    func setPlaying() {
        state = .playing
    }
    
    func resetToInitial() {
        state = .initial
    }
}
