//
//  GetTestResponseMapper.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import Foundation

struct GetTestResponseMapper {
    static func map(from response: Any) -> Test? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let paid = data["paid"] as? Bool,
            let userTestId = data["user_test_id"] as? Int,
            let questionsJSON = data["questions"] as? [[String: Any]]
        else {
            return nil
        }
        
        let questions: [Question] = Self.map(from: questionsJSON)
        
        guard !questions.isEmpty else { return nil }
        
        return Test(
            paid: paid,
            userTestId: userTestId,
            questions: questions
        )
    }
}

// MARK: Private
private extension GetTestResponseMapper {
    static func map(from questions: [[String: Any]]) -> [Question] {
        questions.compactMap { restJSON -> Question? in
            guard
                let id = restJSON["id"] as? Int,
                let question = restJSON["question"] as? String,
                let multiple = restJSON["multiple"] as? Bool,
                let answersJSON = restJSON["answers"] as? [[String: Any]]
            else {
                return nil
            }
            
            let explanation = restJSON["explanation"] as? String
            let answers: [Answer] = Self.map(from: answersJSON)
            guard !answers.isEmpty else { return nil }
            
            let image = restJSON["image"] as? URL
            let video = restJSON["video"] as? URL
            
            return Question(
                id: id,
                image: image,
                video: video,
                question: question,
                answers: answers,
                multiple: multiple,
                explanation: explanation
            )
        }
    }
    
    static func map(from answers: [[String: Any]]) -> [Answer] {
        answers.compactMap { restJSON -> Answer? in
            guard
                let id = restJSON["id"] as? Int,
                let answer = restJSON["answer"] as? String,
                let correct = restJSON["correct"] as? Bool
            else {
                return nil
            }
            
            return Answer(id: id, answer: answer, isCorrect: correct)
        }
    }
}
