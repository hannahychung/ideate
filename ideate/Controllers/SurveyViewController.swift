//
//  SurveyViewController.swift
//  ideate
//
//  Created by Hannah Chung on 3/28/26.
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
        
    var user: IdeateUser? = nil
    
    var currentQuestion = 0 {
        didSet {
            progressBar.progress = Float(currentQuestion + 1) / Float(survey.questions.count)
                    
                    let isLast = currentQuestion == survey.questions.count - 1
                    
                    submitButton.isEnabled = isLast
                    submitButton.isHidden = !isLast
                    
                    backArrowButton.isHidden = (currentQuestion == 0)
                    nextArrowButton.isHidden = isLast
        }
    }
        
    var currentAnswers: [(String, [Trait])] = []
    
    var survey = Survey.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
        submitButton.isHidden = true
        loadQuestion()
    }
    
    func loadQuestion() {
        let question = survey.getQuestion(i: currentQuestion)
        questionLabel.text = question.getQuestionText()
//        print(question.getAnswers())
        currentAnswers = question.getAnswers()
//        print(currentAnswers.count)print
        
        let selectedAnswer = survey.userAnswers[currentQuestion].0
        
        for i in 0..<answerButtons.count {
            if i < currentAnswers.count {
                    answerButtons[i].setTitle(currentAnswers[i].0, for: .normal)
                    answerButtons[i].isEnabled = true
                    answerButtons[i].isHidden = false
                
                if currentAnswers[i].0 == selectedAnswer {
                    answerButtons[i].backgroundColor = UIColor.systemGray3
                } else {
                    answerButtons[i].backgroundColor = UIColor.systemGray5
                }
                } else {
                    answerButtons[i].setTitle("", for: .normal)
                    answerButtons[i].isEnabled = false
                    answerButtons[i].isHidden = true
                }
            }
        
        
    }

    @IBAction func nextArrow(_ sender: UIButton) {
        if currentQuestion < survey.questions.count - 1 {
            let current = survey.userAnswers[currentQuestion]
                if current.0 == "" {
                    print("no answer selected")
                    return
            }
            currentQuestion += 1
            loadQuestion()
        }
    }
    
    
    @IBAction func answerClicked(_ sender: UIButton) {
        let ansIndex = sender.tag
        let currentAns = currentAnswers[ansIndex]
        survey.addUserAnswer(i: currentQuestion, ans: currentAns.0, tra: currentAns.1)
        
        for i in 0..<currentAnswers.count {
                if i == ansIndex {
                    answerButtons[i].backgroundColor = UIColor.systemGray3
                } else {
                    answerButtons[i].backgroundColor = UIColor.systemGray5
                }
            }
        //print("answer: \(currentAns.0)")
        if currentQuestion < survey.questions.count - 1 {
            currentQuestion += 1
            loadQuestion()
        }
    }
    
    @IBAction func backArrow(_ sender: UIButton) {
        if currentQuestion > 0 {
                currentQuestion -= 1
                loadQuestion()
        }
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        print("submit")
        guard let user = user else {
            return
        }
        
        let traits = survey.compileTraits()
   
        for trait in traits {
            let temp = TraitEntity(context: user.managedObjectContext!)
            temp.type = trait.type
            temp.strength = Int16(trait.strength)
            temp.user = user
            print(temp)
        }
        
        try? user.managedObjectContext?.save()

        //user.updateTraits(newTraits: survey.compileTraits())
//        print("TEST: \(user?.username)")
//        print(user?.userTraits)
        performSegue(withIdentifier: "toIDSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIDSegue" {
            let destinationVC = segue.destination as! IDViewController
            destinationVC.user = self.user
            destinationVC.modalPresentationStyle = .fullScreen

        }
    }
}
