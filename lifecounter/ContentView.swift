//
//  ContentView.swift
//  lifecounter
//
//  Created by Non on 17/4/2567 BE.
//

import SwiftUI

struct ContentView: View {
    @State private var players: [Int] = Array(repeating: 20, count: 4)
    @State private var loser: String?
    @State private var gameStarted = false
    @State private var history: [String] = []

    var body: some View {
        NavigationView {
            VStack {
                Button("Add Player") {
                    if players.count < 8 {
                        players.append(20)
                        history.append("Added Player \(players.count)")
                    }
                }
                .disabled(gameStarted || players.count >= 8)

                ScrollView {
                    ForEach(players.indices, id: \.self) { index in
                        PlayerView(lifeTotal: $players[index], playerName: "Player \(index + 1)", history: $history)
                            .padding()
                            .onChange(of: players[index]) { _ in
                                gameStarted = true
                                checkForLoser()
                            }
                    }
                }
                .frame(maxHeight: .infinity)

                if let loser = loser {
                    Text("\(loser) LOSES!")
                        .font(.title)
                        .foregroundColor(.red)
                }

                NavigationLink("History", destination: HistoryView(history: history))
            }
            .navigationBarTitle("Life Counter", displayMode: .inline)
        }
    }

    private func checkForLoser() {
        for (index, life) in players.enumerated() where life <= 0 {
            loser = "Player \(index + 1)"
            history.append("\(loser!) LOSES!")
            break
        }
    }
}

struct PlayerView: View {
    @Binding var lifeTotal: Int
    var playerName: String
    @Binding var history: [String]
    @State private var changeAmount: String = ""

    var body: some View {
        VStack {
            Text(playerName)
                .font(.headline)
            Text("\(lifeTotal)")
                .font(.largeTitle)
            HStack {
                TextField("Change", text: $changeAmount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)
                Button("−") {
                    applyChange(-1)
                }
                Button("+") {
                    applyChange(1)
                }
            }
        }
    }

    private func applyChange(_ direction: Int) {
        if let amount = Int(changeAmount) {
            let adjustedAmount = amount * direction
            lifeTotal += adjustedAmount
            history.append("\(playerName) \(direction == 1 ? "gained" : "lost") \(abs(adjustedAmount)) life.")
            lifeTotal = max(lifeTotal, 0)
        }
        changeAmount = ""
    }
}

struct HistoryView: View {
    var history: [String]
    
    var body: some View {
        List(history, id: \.self) { entry in
            Text(entry)
        }
        .navigationBarTitle("History")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
