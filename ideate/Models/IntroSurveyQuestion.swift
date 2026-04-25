//
//  surveyQuestion.swift
//  ideate
//
//  Created by Hannah Chung on 3/28/26.
//

import UIKit

class IntroSurveyQuestion {
    final var questionText: String
    var answers: [(String, [Trait])]
    init(text: String, answers: [(String, [Trait])]) {
        self.questionText = text
        self.answers = answers
    }
    
    func getQuestionText() -> String {
        return questionText
    }
    
    func getAnswers() -> [(String, [Trait])] {
        return answers
    }
}
