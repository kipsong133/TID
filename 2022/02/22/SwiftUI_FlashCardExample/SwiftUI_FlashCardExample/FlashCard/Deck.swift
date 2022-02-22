//
//  Deck.swift
//  SwiftUI_FlashCardExample
//
//  Created by 김우성 on 2022/02/22.
//

import Foundation

class Deck: ObservableObject {
    @Published var cards: [Card]
    
    init(from cards: [Quiz]) {
        self.cards = cards.map { Card(quiz: $0) }
    }
}
