//
//  Question.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import Foundation

struct Test {
    let paid: Bool
    let userTestId: Int
    let questions: [Question]
}

struct Question {
    let id: Int
    let image: URL?
    let video: URL?
    let question: String
    let answers: [Answer]
    let multiple: Bool
    let explanation: String?
}

struct Answer {
    let id: Int
    let answer: String
    let isCorrect: Bool
}
