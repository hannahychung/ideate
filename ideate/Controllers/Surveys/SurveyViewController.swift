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
        }
    }
                
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
        submitButton.isHidden = true
        loadSurvey()
        loadQuestion()
    }
    
    
    func loadSurvey() {
        guard let survey else { return }

        questions = (survey.questions?.allObjects as? [SurveyQuestion]) ?? []
    }
    
    func loadQuestion() {
        
        guard !questions.isEmpty else { return }

        let question = questions[currentQuestion]
        questionLabel.text = question.question
        currentAnswers = (question.answers?.allObjects as? [SurveyAnswer]) ?? []
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

                //add answer somewhere

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
        print("submit")
        guard let user = user else { return }
        
        //compile traits and save
        
//        for trait in traits {
//            let temp = TraitEntity(context: user.managedObjectContext!)
//            temp.type = trait.type
//            temp.strength = Int16(trait.strength)
//            temp.user = user
//        }
        
        try? user.managedObjectContext?.save()
        
        SessionUser.shared.currentUser = user
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.switchToMainApp(user: user)
        }
    }
 
}
