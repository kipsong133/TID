//
//  DeckView.swift
//  SwiftUI_FlashCardExample
//
//  Created by 김우성 on 2022/02/22.
//

import SwiftUI

enum DismissCardDirection {
    case left
    case right
}

struct DeckView: View {
    
    @StateObject var deck = Deck(from: quizBundle)
    
    let onMemorized: (Card) -> Void = { _ in }
    
    var body: some View {
        ZStack {
            ForEach(deck.cards) { card in
                CardView(card: card) { card, direction in
                    if direction == .left {
                        onMemorized(card)
                    } else {
                        // do something
                    }
                }
            }
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
    }
}
