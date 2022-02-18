//
//  OTestElement.swift
//  Nursing
//
//  Created by Виталий Загороднов on 15.02.2022.
//

import Foundation

struct OAnswerElement {
    let id: Int
    let answer: String
    let image: URL?
    var state: OAnswerState
    let isCorrect: Bool
}

enum OAnswerState {
    case initial, correct, warning, error
}

struct OQuestionElement {
    let id: Int
    let elements: [OTestCellType]
    let isResult: Bool
}

enum OTestCellType {
    case question(String, html: String)
    case answer(OAnswerElement)
    case explanation(String)
    case comment(isError: Bool, comment: String?)
}
