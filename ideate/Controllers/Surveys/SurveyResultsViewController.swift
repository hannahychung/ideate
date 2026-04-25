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
    
    var tips: [String] = []
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var firstRec: UIButton!
    @IBOutlet weak var secondRec: UIButton!
    @IBOutlet weak var thirdRec: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = SessionUser.shared.currentUser
        if let answers = answers {
            result = compileTraits(answers: answers)
            resultLabel.text = result
        }

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
