//
//  SurveyViewController.swift
//  ideate
//
//  Created by Hannah Chung on 4/25/26.
//

import UIKit
import CoreData

class SurveyViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet var answerButtons: [UIButton]!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var backArrowButton: UIButton!
    
    @IBOutlet weak var nextArrowButton: UIButton!
        
    let context = persistentContainer.viewContext

    var user: IdeateUser? = nil
    var survey: Survey? = nil
    var questions: [SurveyQuestion] = []
    var currentAnswers: [SurveyAnswer] = []
    
    var currentQuestion = 0 {
        didSet {
            var isLast = true
            
            if let survey = survey, let questions = survey.questions {
                progressBar.progress = Float(currentQuestion + 1) / Float(survey.questions!.count)
                isLast = currentQuestion == questions.count - 1
            }
                submitButton.isEnabled = isLast
                submitButton.isHidden = !isLast

                backArrowButton.isHidden = (currentQuestion == 0)
                nextArrowButton.isHidden = isLast
            
            loadQuestion()
        }
    }
                
    override func viewDidLoad() {
        super.viewDidLoad()
        user = SessionUser.shared.currentUser
        submitButton.isEnabled = false
        submitButton.isHidden = true
        loadSurvey()
        loadQuestion()
    }
    
    
    func loadSurvey() {
        guard let survey else { return }
        if let qs = survey.questions{
            questions = qs.allObjects as! [SurveyQuestion]
        }
       
    }
    
    func loadQuestion() {
        
        guard !questions.isEmpty else { return }

        let question = questions[currentQuestion]
        if let questionText = question.question {
            questionLabel.text = questionText
            print("QUESTION: \(questionText)")
        } else {
            print("no such question")
        }
        if let ans = question.answers {
            currentAnswers = ans.allObjects as! [SurveyAnswer]
        }
       
        loadAnswers()
    }
    
    func loadAnswers() {
        for i in 0..<answerButtons.count {
            if i < currentAnswers.count {
                answerButtons[i].setTitle(currentAnswers[i].answer, for: .normal)
                answerButtons[i].isHidden = false
                answerButtons[i].isEnabled = true
                answerButtons[i].backgroundColor = .systemGray5
            } else {
                answerButtons[i].setTitle("", for: .normal)
                answerButtons[i].isHidden = true
                answerButtons[i].isEnabled = false
            }
        }
    }

    @IBAction func nextArrow(_ sender: UIButton) {
        guard currentQuestion < questions.count - 1 else { return }
        currentQuestion += 1
    }
    
    
    @IBAction func answerClicked(_ sender: UIButton) {
        let index = sender.tag
            guard index < currentAnswers.count else { return }

            let selected = currentAnswers[index]

            guard let survey = survey else { return }

            if let allAnswers = currentAnswers as [SurveyAnswer]? {
                for ans in allAnswers {
                    if let traits = ans.traits {
                        for t in traits {
                            let t = t as! SurveyTrait
                            survey.removeFromUserAnswers(t)
                        }
                    }
                }
            }
        
        //adding answer's traits to the user
            if let traits = selected.traits {
                for t in traits {
                    let t = t as! SurveyTrait
                    survey.addToUserAnswers(t)
                }
            }

            for i in 0..<answerButtons.count {
                answerButtons[i].backgroundColor =
                    (i == index) ? .systemGray3 : .systemGray5
            }

            guard currentQuestion < questions.count - 1 else { return }
            currentQuestion += 1
    }
    
    @IBAction func backArrow(_ sender: UIButton) {
        guard currentQuestion > 0 else { return }
                currentQuestion -= 1
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        guard let user = user else { return }
        print("submit")

        if let survey = survey {
            survey.finished = true
        }
        
        try? user.managedObjectContext?.save()
        
        performSegue(withIdentifier: "toSurveyResultsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSurveyResultsSegue" {
            let targetVC = segue.destination as! SurveyResultsViewController
            if let survey = survey, let answers = survey.userAnswers {
                targetVC.answers = answers
                targetVC.survey = survey
            }
        }
    }
 
}
