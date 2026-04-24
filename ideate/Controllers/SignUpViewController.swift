//
//  SignUpViewController.swift
//  ideate
//
//  Created by Hannah Chung on 4/16/26.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {

    let context = persistentContainer.viewContext
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var currentUser: IdeateUser? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.endEditing(true)
        passwordField.endEditing(true)
        return true
    }
    
    @IBAction func createUser(_ sender: UIButton) {
        print("create User pressed")
        if usernameField.hasText && passwordField.hasText {
            let user = usernameField.text
            let _ = passwordField.text
            if userExists(username: user!) {
                print("user already exists, log in")
                return
            } else {
                saveUser(username: usernameField.text!, password: passwordField.text!)
                
                print("created account \(user!)")
                performSegue(withIdentifier: "toSurveySegue", sender: self)
                return
            }
        }
        print("fill in all fields")

    }
    
    func saveUser(username: String, password: String) {
        let user = IdeateUser(context: context)
        currentUser = user
        user.username = username
        user.password = password
        
        do {
            try context.save()
            print("user saved")
        } catch {
            print("error: \(error)")
        }
    }
    
    func userExists(username: String) -> Bool {
        let request: NSFetchRequest<IdeateUser> = IdeateUser.fetchRequest()
        
        request.predicate = NSPredicate(format: "username == %@", username)
        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            print("error checking user: \(error)")
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSurveySegue" {
            let destinationVC = segue.destination as! SurveyViewController
            destinationVC.user = self.currentUser
            destinationVC.modalPresentationStyle = .fullScreen
        }
    }


}
