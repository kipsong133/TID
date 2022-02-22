//
//  Card.swift
//  SwiftUI_FlashCardExample
//
//  Created by 김우성 on 2022/02/22.
//

import Foundation

struct Quiz {
    let question: String
    let answer: String
}

// dummy data
let quiz01 = Quiz(question: "class는 Value-Type 이다.", answer: "X")
let quiz02 = Quiz(question: "struct는 Reference-Type타입이다.", answer: "X")
let quiz03 = Quiz(question: "CocoaTouchFramework에는 UIKit이 있다.", answer: "O")
let quiz04 = Quiz(question: "Combine은 iOS 13부터 사용이 가능하다.", answer: "O")
var quizBundle: [Quiz] {
    [quiz01, quiz02, quiz03, quiz04]
}

struct Card: Identifiable {
    var quiz: Quiz
    var id = UUID()
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.quiz.question == rhs.quiz.question
        && lhs.quiz.answer == rhs.quiz.answer
    }
}
