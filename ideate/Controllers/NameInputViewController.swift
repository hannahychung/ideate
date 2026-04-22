//
//  NameInputViewController.swift
//  ideate
//
//  Created by Hannah Chung on 4/3/26.
//

import UIKit
import CoreData

class NameInputViewController: UIViewController, UITextFieldDelegate{

    let context = persistentContainer.viewContext

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var username = ""
    
    var password = ""
    
    //var currentUser: TempUser = TempUser.init()
    var currentUser: IdeateUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.endEditing(true)
        passwordField.endEditing(true)
        return true
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        if usernameField.hasText && passwordField.hasText {
            let user = usernameField.text
            let pw = passwordField.text
            if verifyUser(username: user!, password: pw!) {
                performSegue(withIdentifier: "toIDVC", sender: self)
            } else {
                print("no such user")
                return
            }
        }
        
        print("fill in all fields")
            }
    
    
    func verifyUser(username: String, password: String) -> Bool {
        let request: NSFetchRequest<IdeateUser> = IdeateUser.fetchRequest()
        
        request.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let result = try context.fetch(request)
            
            guard let user = result.first else {
                return false
            }
            
            return user.password == password
            
        } catch {
            print("error: \(error)")
            return false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIDVC" {
            let destinationVC = segue.destination as! IDViewController
            destinationVC.user = self.currentUser
            destinationVC.modalPresentationStyle = .fullScreen

        }
    }

}
