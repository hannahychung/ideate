//
//  LoginViewController.swift
//  ideate
//
//  Created by Hannah Chung on 3/25/26.
//

import UIKit


class LoginViewController: UIViewController {
    override func viewDidLoad() {
        
    }

    @IBAction func logIn(_ sender: UIButton) {
        performSegue(withIdentifier: "toNameInput", sender: self)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignUpSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNameInput" {
            let destinationVC = segue.destination as! NameInputViewController
            destinationVC.modalPresentationStyle = .fullScreen
        } else if segue.identifier == "toSignUpSegue" {
            let destinationVC = segue.destination as! SignUpViewController
            destinationVC.modalPresentationStyle = .fullScreen
        }
    }
}
