//
//  ContentView.swift
//  My Cards
//
//  Created by Conner Yoon on 6/29/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Card.timestamp, order: .reverse) private var cards: [Card]
    @State private var newCard : Card?
    var body: some View {
        NavigationStack {
            List {
                ForEach(cards) { card in
                    NavigationLink {
                        CardEditView(card: card, save: { _ in})
                    } label: {
                       CardRowView(card: card)
                    }
                }
            }
            
            .listStyle(.plain)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        newCard = Card()
                    }) {
                        
                        Label("Add Card", systemImage: "plus")
                    }
                }
            }.navigationTitle("MY CARDS")
                .sheet(item: $newCard) { card in
                    NavigationStack{
                        CardEditView(card: card) { card in
                            modelContext.insert(card)
                        }
                    }
                }
              
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Card(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(cards[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Card.self, inMemory: true)
}

struct CardDetailView : View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            Button("Photo Picker"){
                
            }
            Rectangle()
            Button("Delete"){
                dismiss()
            }
        }
    }
}


