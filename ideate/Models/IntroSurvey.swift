//
//  Survey.swift
//  ideate
//
//  Created by Hannah Chung on 3/28/26.
//

import Foundation

struct IntroSurvey {
    var questions: [IntroSurveyQuestion] = []
    var userAnswers: [(String, [Trait])] = []
    
    init() {

        addQuestion(
            questionText: "how would you describe yourself?",
            answers: [
                ("designer", [Trait(type: "exploration", strength: 1), Trait(type: "action", strength: 1)]),
                ("entrepreneur", [Trait(type: "action", strength: 2)]),
                ("student", [Trait(type: "guidance", strength: 2)]),
                ("exploring", [Trait(type: "exploration", strength: 2), Trait(type: "inspiration", strength: 1)])
            ]
        )
        
        addQuestion(
            questionText: "what are you hoping to use ideate for?",
            answers: [
                ("build a brand", [Trait(type: "action", strength: 1), Trait(type: "inspiration", strength: 1)]),
                ("create a product", [Trait(type: "action", strength: 2)]),
                ("brainstorm ideas", [Trait(type: "exploration", strength: 1), Trait(type: "inspiration", strength: 2)]),
                ("design visuals", [Trait(type: "exploration", strength: 1), Trait(type: "inspiration", strength: 1)])
            ]
        )

        addQuestion(
            questionText: "how comfortable are you with design?",
            answers: [
                ("beginner", [Trait(type: "guidance", strength: 2)]),
                ("intermediate", [Trait(type: "exploration", strength: 1)]),
                ("advanced", [Trait(type: "exploration", strength: 2), Trait(type: "action", strength: 1)])
            ]
        )

        addQuestion(
            questionText: "which style fits you best?",
            answers: [
                ("minimal", [Trait(type: "guidance", strength: 1)]),
                ("bold", [Trait(type: "exploration", strength: 1)]),
                ("modern", [Trait(type: "action", strength: 1)]),
                ("playful", [Trait(type: "exploration", strength: 1), Trait(type: "inspiration", strength: 1)])
            ]
        )

        addQuestion(
            questionText: "where do you like to start creating?",
            answers: [
                ("with a clear, guided process", [Trait(type: "guidance", strength: 3)]),
                ("explore and experiment", [Trait(type: "exploration", strength: 3)]),
                ("look for inspiration first", [Trait(type: "inspiration", strength: 3), Trait(type: "guidance", strength: 1)]),
                ("jump straight into building", [Trait(type: "action", strength: 3)])
            ]
        )
        for _ in 0..<questions.count {
            userAnswers.append(("", []))
        }
    }
    
    mutating func addQuestion(questionText: String, answers: [(String, [Trait])]) {
        questions.append(IntroSurveyQuestion(text: questionText, answers: answers))
    }
    
    func getAnswers(i: Int) -> [(String, [Trait])] {
        return questions[i].getAnswers()
    }
    
    func compileTraits() -> [Trait]{
        var temp: [Trait] = [Trait(type: "guidance", strength: 0), Trait(type: "exploration", strength: 0), Trait(type: "inspiration", strength: 0), Trait(type: "action", strength: 0)]
        
        for (_, traits) in userAnswers {
                for trait in traits {
                    for i in 0..<temp.count {
                        if temp[i].type == trait.type {
                            temp[i].strength += trait.strength
                        }
                    }
                }
            }
        
        return temp
    }
    
    func getQuestion(i: Int) -> IntroSurveyQuestion{
        return questions[i]
    }
    
    mutating func addUserAnswer(i: Int, ans: String, tra: [Trait]) {
        userAnswers[i] = (ans, tra)
    }
    
}
