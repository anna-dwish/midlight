//
//  SignInViewController.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/17/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit
import Firebase
class SignInVC: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signin: UIButton!
    @IBOutlet weak var signinAid: UILabel!
    
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func enableSignIn(){
        if (username.text?.isEmpty ?? true || password.text?.isEmpty ?? true) {
            signinAid.textColor = UIColor.black
            signinAid.text = "Please enter both fields"
            return
        }
        validateSignIn()
    }
        
    func validateSignIn(){
        Auth.auth().signIn(withEmail: username.text!, password: password.text!) { [weak self] authResult, error in
        if error != nil {
            self?.signinAid.textColor = UIColor.black
            self?.signinAid.text = "Invalid Login"
            return
        }
        self?.performSegue(withIdentifier: "signUserIn", sender: self)
      }
    }


}
