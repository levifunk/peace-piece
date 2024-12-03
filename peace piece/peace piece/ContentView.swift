//
//  ContentView.swift
//  peace piece
//
//  Created by Levi Funk on 12/3/24.
//

import SwiftUI

enum ButtonState {
    case initial
    case cued
    case playing
}

@MainActor
class GridViewModel: ObservableObject {
    @Published var buttonViewModels: [[ButtonViewModel]] = []
    @Published var cuedChoices: [Int?] = [nil, nil, nil, nil] // One cued ID per column
    @Published var playingChoices: [Int?] = [nil, nil, nil, nil] // One playing ID per column
    
    init(specificIDs: [[Int]]) {
        for (col, ids) in specificIDs.enumerated() {
            let columnModels = ids.map { id in
                let viewModel = ButtonViewModel(id: id, column: col)
                viewModel.onStateChange = { [weak self] newState in
                    self?.handleStateChange(for: viewModel, newState: newState)
                }
                return viewModel
            }
            buttonViewModels.append(columnModels)
        }
    }
    
    private func handleStateChange(for button: ButtonViewModel, newState: ButtonState) {
        switch newState {
        case .cued:
            updateColumnState(for: button.column, with: button.id, in: &cuedChoices)
        case .playing:
            updateColumnState(for: button.column, with: button.id, in: &playingChoices)
        case .initial:
            if cuedChoices[button.column] == button.id {
                cuedChoices[button.column] = nil
            }
            if playingChoices[button.column] == button.id {
                playingChoices[button.column] = nil
            }
        }
    }
    
    private func updateColumnState(for column: Int, with buttonID: Int, in choices: inout [Int?]) {
        if let previousID = choices[column], let previousButton = findButton(by: previousID) {
            previousButton.resetToInitial()
        }
        choices[column] = buttonID
    }
    
    private func findButton(by id: Int) -> ButtonViewModel? {
        for column in buttonViewModels {
            if let button = column.first(where: { $0.id == id }) {
                return button
            }
        }
        return nil
    }
}

class ButtonViewModel: ObservableObject, Identifiable {
    let id: Int
    let column: Int
    @Published var state: ButtonState = .initial {
        didSet {
            onStateChange?(state)
        }
    }
    
    var onStateChange: ((ButtonState) -> Void)?
    
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

struct StateCell: View {
    @ObservedObject var viewModel: ButtonViewModel
    
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


struct ContentView: View {
    private let specificIDs = [
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16]
    ]
    
    @StateObject private var gridViewModel = GridViewModel(specificIDs: specificIDs)
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<4) { row in
                    ForEach(0..<4) { col in
                        StateCell(viewModel: gridViewModel.buttonViewModels[col][row])
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .padding(10)
            
            // Display the cued and playing choices
            VStack {
                Text("Cued Choices: \(gridViewModel.cuedChoices.map { $0?.description ?? "None" }.joined(separator: ", "))")
                Text("Playing Choices: \(gridViewModel.playingChoices.map { $0?.description ?? "None" }.joined(separator: ", "))")
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
