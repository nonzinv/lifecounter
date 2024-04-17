//
//  ContentView.swift
//  lifecounter
//
//  Created by Non on 17/4/2567 BE.
//

import SwiftUI

struct ContentView: View {
    @State private var player1Life = 20
    @State private var player2Life = 20
    @State private var loser: String?

    var body: some View {
        VStack(spacing: 20) {
            PlayerView(lifeTotal: $player1Life, playerName: "Player 1")
            PlayerView(lifeTotal: $player2Life, playerName: "Player 2")
            if let loser = loser {
                Text("\(loser) LOSES!")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .onChange(of: player1Life) { newValue in
            checkForLoser(lifeTotal: newValue, playerName: "Player 1")
        }
        .onChange(of: player2Life) { newValue in
            checkForLoser(lifeTotal: newValue, playerName: "Player 2")
        }
    }

    private func checkForLoser(lifeTotal: Int, playerName: String) {
        if lifeTotal <= 0 {
            loser = playerName
        }
    }
}

struct PlayerView: View {
    @Binding var lifeTotal: Int
    var playerName: String

    var body: some View {
        VStack {
            Text(playerName)
                .font(.headline)
            Text("\(lifeTotal)")
                .font(.largeTitle)
            HStack {
                Button(action: { updateLife(by: -5) }) {
                    Text("-5")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(5)
                }
                Button(action: { updateLife(by: -1) }) {
                    Text("-")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(5)
                }
                Button(action: { updateLife(by: 1) }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(5)
                }
                Button(action: { updateLife(by: 5) }) {
                    Text("+5")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(5)
                }
            }
        }
    }

    private func updateLife(by amount: Int) {
        let newLifeTotal = lifeTotal + amount
        lifeTotal = max(newLifeTotal, 0)  // Ensure life total never goes below zero
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
