//
//  ContentView.swift
//  peace piece
//
//  Created by Levi Funk on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var gridViewModel = Conductor(specificIDs: [
        [12, 13, 14, 15],
        [17, 18, 19, 20],
        [22, 23, 24, 25],
        [27, 28, 29, 30]
    ])
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<4) { row in
                    ForEach(0..<4) { col in
                        PadView(viewModel: gridViewModel.buttonViewModels[col][row])
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
