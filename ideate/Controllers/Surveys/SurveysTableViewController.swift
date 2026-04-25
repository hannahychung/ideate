//
//  SurveysTableViewController.swift
//  ideate
//
//  Created by Hannah Chung on 4/25/26.
//

import UIKit
import CoreData

class SurveysTableViewController: UITableViewController {

    let context = persistentContainer.viewContext
    var user: IdeateUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = SessionUser.shared.currentUser
        if let user = user {
            if user.surveys?.count == 0 {
                initializeSurveys()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = user, let surveys = user.surveys {
            return surveys.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell", for: indexPath) as! SurveyTableViewCell
        if let user = user,
           let surveys = user.surveys{
            
            let surveysArray = returnSortedArray(surveys: surveys)
            
            let survey = surveysArray[indexPath.row]
            cell.surveyLabel.text = survey.title
            if survey.finished {
                cell.surveyIcon.text = "✔️"
            } else {
                cell.surveyIcon.text = "◼️"
            }
        }
        return cell
    }
    
    func initializeSurveys() {
        if let user = user {
            // New Project Survey:
            let newProjectSurvey = Survey(context: context)
            newProjectSurvey.user = user
            newProjectSurvey.title = "Making a New Project"
            newProjectSurvey.finished = false
            
            //Adding Questions
            
            // Q1
            addQuestion(
                text: "what kind of project are you starting?",
                answers: [
                    ("brand identity / startup", [("modern_clean", 1)]),
                    ("personal portfolio", [("minimalist", 1)]),
                    ("social content / media page", [("young_trendy", 1)]),
                    ("creative experiment", [("bold_expressive", 1)])
                ],
                context: context,
                survey: newProjectSurvey
            )

            // Q2
            addQuestion(
                text: "what feeling should your project give off?",
                answers: [
                    ("sleek and professional", [("modern_clean", 1)]),
                    ("calm and simple", [("minimalist", 1)]),
                    ("fun and energetic", [("young_trendy", 1)]),
                    ("creative and attention-grabbing", [("bold_expressive", 1)])
                ],
                context: context,
                survey: newProjectSurvey
            )

            // Q3
            addQuestion(
                text: "which visual direction do you gravitate toward?",
                answers: [
                    ("structured and intuitive", [("modern_clean", 1)]),
                    ("stripped-back and simple", [("minimalist", 1)]),
                    ("colorful and trendy", [("young_trendy", 1)]),
                    ("experimental and eye-catching", [("bold_expressive", 1)])
                ],
                context: context,
                survey: newProjectSurvey
            )

            // Q4
            addQuestion(
                text: "how would you describe your audience?",
                answers: [
                    ("professionals, clients, businesses", [("modern_clean", 1), ("minimalist", 1)]),
                    ("students and young adults", [("young_trendy", 1)]),
                    ("creatives, designers", [("bold_expressive", 1), ("minimalist", 1)])
                ],
                context: context,
                survey: newProjectSurvey
            )

            // Q5
            addQuestion(
                text: "what are you taking inspiration from?",
                answers: [
                    ("tech brands and modern interfaces", [("modern_clean", 1)]),
                    ("architecture, grids, editorial design", [("minimalist", 1)]),
                    ("trends, creators, internet culture", [("young_trendy", 1)]),
                    ("posters, art, expressive visuals", [("bold_expressive", 1)])
                ],
                context: context,
                survey: newProjectSurvey
            )
            
            print("created new surveys")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toSurveyPageSegue", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSurveyPageSegue" {
            if let targetVC = segue.destination as? SurveyViewController, let indexPath = sender as? IndexPath, let user = user, let surveys = user.surveys {
                let surveyArray = returnSortedArray(surveys: surveys)
                let survey = surveyArray[indexPath.row]
                targetVC.survey = survey
                print("survey selected: \(survey.title ?? "no survey")")
            }
        }
    }

    
    /// MARK: Helper Functions
    
    func addAnswer(
        to question: SurveyQuestion,
        context: NSManagedObjectContext,
        text: String,
        traits: [(String, Int)]
    ) {
        let answer = SurveyAnswer(context: context)
        answer.answer = text

        for trait in traits {
            let t = SurveyTrait(context: context)
            t.name = trait.0
            t.strength = Int16(trait.1)
            answer.addToTraits(t)
        }

        question.addToAnswers(answer)
    }
    
    func addQuestion(
        text: String,
        answers: [(String, [(String, Int)])],
        context: NSManagedObjectContext,
        survey: Survey
    ) {
        let q = SurveyQuestion(context: context)
        q.question = text

        for a in answers {
            addAnswer(to: q,
                      context: context,
                      text: a.0,
                      traits: a.1)
        }

        survey.addToQuestions(q)
    }
    
    func returnSortedArray(surveys: NSSet) -> [Survey]{
        let surveyArray = (surveys.allObjects as! [Survey]).sorted {
            $0.title ?? "" < $1.title ?? ""
        }
        return surveyArray
    }
    

}
