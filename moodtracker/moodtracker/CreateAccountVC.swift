//
//  CreateAccountViewController.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/17/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountVC: UIViewController {

    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var createAccountAid: UILabel!
    @IBOutlet weak var createAccount: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccount.addTarget(self, action: #selector(enableAccount), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func enableAccount(){
        if (email.text?.isEmpty ?? true || password.text?.isEmpty ?? true || confirmPassword.text?.isEmpty ?? true) {
            createAccountAid.textColor = UIColor.black
            createAccountAid.text = "Please complete all fields"
            return
        }
        else if (password.text != confirmPassword.text){
            createAccountAid.textColor = UIColor.black
            createAccountAid.text = "Passwords do not match"
            return
        }
        validateAccount()
    }
        
    func validateAccount(){
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { [weak self] authResult, error in
        if error != nil {
            self?.createAccountAid.textColor = UIColor.black
            self?.createAccountAid.text = "Please use a different email"
            return
        }
        Auth.auth().signIn(withEmail: (self?.email.text!)!, password: (self?.password.text!)!)
        self?.performSegue(withIdentifier: "beginQuestionnaire", sender: self)
      }
        
    }

}
