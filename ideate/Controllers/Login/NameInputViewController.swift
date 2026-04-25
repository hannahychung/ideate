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
        passwordField.isSecureTextEntry = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.endEditing(true)
        passwordField.endEditing(true)
        return true
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        guard let username = usernameField.text,
                  let password = passwordField.text,
                  !username.isEmpty,
                  !password.isEmpty else {
                print("fill in all fields")
                return
            }

            if verifyUser(username: username, password: password) {
                
                SessionUser.shared.currentUser = currentUser
                
                if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate,
                       let user = currentUser {
                        sceneDelegate.switchToMainApp(user: user)
                    }
            } else {
                print("invalid username or password")
            }
        }
    
    
    func verifyUser(username: String, password: String) -> Bool {
        let request: NSFetchRequest<IdeateUser> = IdeateUser.fetchRequest()
           request.predicate = NSPredicate(format: "username == %@", username)
           
           do {
               let result = try context.fetch(request)
               
               guard let user = result.first else {
                   return false
               }
               
               if user.password == password {
                   currentUser = user
                   return true
               } else {
                   return false
               }
               
           } catch {
               print("error: \(error)")
               return false
           }
    }

}
