//
//  SurveyResultsViewController.swift
//  ideate
//
//  Created by Hannah Chung on 4/25/26.
//

import UIKit
import CoreData

class SurveyResultsViewController: UIViewController {
    
    let context = persistentContainer.viewContext
    var user: IdeateUser? = nil
    var answers: NSSet? = nil
    var result: String = ""
    var survey: Survey? = nil
    
    var tips: [String] = ["", "", ""]
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var firstRec: UIButton!
    @IBOutlet weak var secondRec: UIButton!
    @IBOutlet weak var thirdRec: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = SessionUser.shared.currentUser
        if let answers = answers {
            result = compileTraits(answers: answers)
            presentResults(result)
        }

    }
    
    func presentResults(_ result: String) {
        var resultText = ""
        
        if survey?.title == "Making a New Project" {
            switch result {
            case "modern_clean":
                resultText = "Your project leans towards a more modern, clean, and timeless look that appeals to professionals and establishes credibility."
                tips[0] = "Key words: professional, intuitive, confident"
                tips[1] = "Use clean layouts and avoid clutter."
                tips[2] = "Stick to a simple color palette."
            case "minimalist":
                resultText = "Your project may benefit from being more minimalist rather than flashy or expressive, focusing on subtle details to tell a message."
                tips[0] = "Key words: minimal, calm, refined"
                tips[1] = "Limit elements and avoid wordiness."
                tips[2] = "Use whitespace and text more than visuals."
            case "young_trendy":
                resultText = "Your project is geared towards being more youthful and fresh, with a style that is exciting and fun."
                tips[0] = "Key words: playful, energetic, trendy"
                tips[1] = "Take a look at what designs are popular right now."
                tips[2] = "Try adding interesting animations and elements."
            case "bold_expressive":
                resultText = "Your project should be expressive and bold, with a unique design style that speaks on its own."
                tips[0] = "Key words: bold, creative, unique"
                tips[1] = "Use strong contrast, large text, and standout visuals"
                tips[2] = "Don’t be afraid to break traditional layout rules."
            default:
                resultText = "[no result]"
            }
        }
        resultLabel.text = resultText
        firstRec.setTitle(tips[0], for: .normal)
        secondRec.setTitle(tips[1], for: .normal)
        thirdRec.setTitle(tips[2], for: .normal)
    }
    
    func compileTraits(answers: NSSet) -> String {
        
        var traitArray: [Int] = [0, 0, 0, 0]
        
        if survey?.title == "Making a New Project" {
            
            for n in answers {
                let n = n as! SurveyTrait
                switch n.name {
                case "modern_clean": traitArray[0] += Int(n.strength)
                case "minimalist": traitArray[1]  += Int(n.strength)
                case "young_trendy": traitArray[2]  += Int(n.strength)
                case "bold_expressive": traitArray[3]  += Int(n.strength)
                default: continue
                }
            }
            
            switch traitArray.indices.max(by: {traitArray[$0] < traitArray[$1]}) {
            case 0: return "modern_clean"
            case 1: return "minimalist"
            case 2: return "young_trendy"
            case 3: return "bold_expressive"
            default: break
            }
        }
        
        return ""
    }
    
    @IBAction func selectedFirst(_ sender: UIButton) {
        
        presentProjectSelector(tag: sender.tag)
    }
    
    @IBAction func selectedSecond(_ sender: UIButton) {
        
        presentProjectSelector(tag: sender.tag)
    }
    
    @IBAction func selectedThird(_ sender: UIButton) {
        
        presentProjectSelector(tag: sender.tag)
    }
    
    func presentProjectSelector(tag: Int) {
        let popup = UIAlertController(title: "Project", message: "Choose a project to import this tip to.", preferredStyle: .alert)
        
        if let user = user, let projectlist = user.projectlist, let projects = projectlist.projects {
            if projects.allObjects.count == 0 { //if there are no projects available yet
                //add some message?
            } else {
                for n in projects.allObjects {
                    let n = n as! Project
                    let projectName = n.name
                    popup.addAction(UIAlertAction(title: projectName, style: .default) { _ in
                        let temp = ProjectCell(context: self.context)
                        temp.textValue = self.tips[tag]
                        temp.project = n
                        temp.type = "text"
                        if let cells = n.cells {
                            temp.order = Int16(cells.count)
                        } else {
                            temp.order = 0
                        }
                        n.addToCells(temp)
                        try? self.context.save()
                    })
                }
            }
        }
        
        
        present(popup, animated: true)
    }
    
}
