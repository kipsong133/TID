//
//  CardView.swift
//  SwiftUI_FlashCardExample
//
//  Created by 김우성 on 2022/02/22.
//

import SwiftUI

struct CardView: View {
    typealias CardDrag = (_ card: Card,
                          _ direction: DismissCardDirection) -> Void
    let dragged: CardDrag
    
    var card: Card
    @State var offset: CGSize = .zero
    
    
    init(
        card: Card,
        onDrag dragged: @escaping CardDrag = {_, _ in }) {
            self.card = card
            self.dragged = dragged
        }
    
    var body: some View {
        
        let drag = DragGesture()
            .onChanged { offset = $0.translation }
            .onEnded {
                // move left
                if $0.translation.width < -100 {
                    // dismiss left
                    offset = .init(width: -1000, height: 0)
                    // memorized card
                    dragged(card, .left)
                    
                // move right
                } else if $0.translation.width > 100 {
                    // dismiss right
                    offset = .init(width: 1000, height: 0)
                    // memorized card
                    dragged(card, .right)
                
                // move in the middle
                } else {
                    // move base
                    offset = .zero
                }
            }
        
        return ZStack {
            // setup BackgroundColor
            Rectangle()
                .fill(Color.blue)
                .frame(width: 320, height: 210)
                .cornerRadius(12)
            
            VStack {
                Spacer()
                Group {
                    Text(card.quiz.question)
                        .font(.largeTitle)
                    
                    Text(card.quiz.answer)
                        .font(.caption)
                }
                .foregroundColor(.white)
                Spacer()
            }
        }
        .shadow(radius: 8)
        .frame(width: 320, height: 210)
        .animation(.spring(), value: offset)
        .offset(offset)
        .gesture(drag)
    }
}

struct CardView_Previews: PreviewProvider {
    @State static var card = Card(quiz: quiz01)
    
    static var previews: some View {
        CardView(card: card)
            .previewLayout(.device)
    }
}

