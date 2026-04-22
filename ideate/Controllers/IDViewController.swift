//
//  IDViewController.swift
//  ideate
//
//  Created by Hannah Chung on 3/31/26.
//

import UIKit

class IDViewController: UIViewController {
    
    @IBOutlet weak var myID: UILabel!
                
    @IBOutlet weak var idPic: UIImageView!
    
    @IBOutlet weak var userDescription: UILabel!
    
    let pictures: [String] = ["id-01", "id-02", "id-02", "id-03", "id-04", "id-05"]
                
    var currentPicIndex = 0
        
    var user: IdeateUser? = nil

        override func viewDidLoad() {
            super.viewDidLoad()
            
            guard let user = user else {
                    return
                }
            
            if user.username == "" {
                myID.text = "Your ID"
            } else {
                myID.adjustsFontSizeToFitWidth = true
                //myID.text = "\(user.getUsername())'s ID"
            }
            userDescription.adjustsFontSizeToFitWidth = true
            userDescription.text = updateUserDesc()
        }

        @IBAction func nextPic(_ sender: UIButton) {
            currentPicIndex = currentPicIndex + 1
            if currentPicIndex > 5 {
                currentPicIndex = 0
            }
            
            idPic.image = UIImage(named: pictures[currentPicIndex])
        }
        
        
        @IBAction func backPic(_ sender: UIButton) {
            
            currentPicIndex = currentPicIndex - 1
            if currentPicIndex < 0 {
                currentPicIndex = 5
            }
            
            idPic.image = UIImage(named: pictures[currentPicIndex])
        }
        
        @IBAction func randomPic(_ sender: UIButton) {
            
            currentPicIndex = Int.random(in: 0...5)
            
            idPic.image = UIImage(named: pictures[currentPicIndex])
        }
    
    func updateUserDesc() -> String {
        guard let traits = user?.traits else {
            return "no traits"
        }
 
        var guideText = ""
        
        var inspoText = ""
        var guidanceStr = 0
        var explorationStr = 0
        var inspirationStr = 0
        var actionStr = 0
        
        for trait in traits {
            if (trait as! TraitEntity).type == "guidance" {
                guidanceStr = Int((trait as! TraitEntity).strength)
            }
            if (trait as! TraitEntity).type == "exploration" {
                explorationStr = Int((trait as! TraitEntity).strength)
            }
            if (trait as! TraitEntity).type == "inspiration" {
                inspirationStr = Int((trait as! TraitEntity).strength)
            }
            if (trait as! TraitEntity).type == "action" {
                actionStr = Int((trait as! TraitEntity).strength)
            }
        }
        
        if guidanceStr > explorationStr {
            guideText = "You prefer clear structure and direction when creating."
        } else if guidanceStr < explorationStr {
            guideText = "You prefer experimenting and discovering ideas as you go."
        } else {
            guideText = "You balance structure with flexibility in your process."
        }
        
        if inspirationStr > actionStr {
            inspoText = "You have broad ideas that you want to solidfy through inspiration and ideation."
        } else if inspirationStr < actionStr {
            inspoText = "You have goals in mind that you're ready to jump in and start working on."
        } else {
            inspoText = "You're looking for a balance between ideation and execution."
        }
        
//
//        if traits[0].strength > traits[1].strength {
//            likesGuidance = 0
//        } else if traits[0].strength < traits[1].strength {
//            likesGuidance = 1
//        } else {
//            likesGuidance = 2
//        }
//        
//        if traits[2].strength > traits[3].strength {
//            inspiration = 0
//        } else if traits[2].strength < traits[3].strength {
//            inspiration = 1
//        } else {
//            inspiration = 3
//        }
//        
       
        
        return "\(guideText) \(inspoText)"
    }

    
    @IBAction func projectsHomeButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toProjectsHomeTable", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProjetoProjectsHomeTablectHome" {
            let destinationVC = segue.destination as! ProjectsHomeTableViewController
            destinationVC.user = self.user!
            destinationVC.modalPresentationStyle = .fullScreen
        }
    }
    
}
