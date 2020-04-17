//
//  SignInViewController.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/17/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signin: UIButton!
    @IBOutlet weak var signinAid: UILabel!
    
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        signin.addTarget(self, action: #selector(enableSignIn), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      handle = Auth.auth().addStateDidChangeListener { (auth, user) in
      }
      
    }
    
    @objc func enableSignIn(){
        if (username.text?.isEmpty ?? true || password.text?.isEmpty ?? true) {
            signinAid.textColor = UIColor.black
            signinAid.text = "Please enter both fields"
            return
        }
        validateSignIn()
    }
        
    func validateSignIn(){
        print("hi")
        Auth.auth().signIn(withEmail: username.text!, password: password.text!) { [weak self] authResult, error in
        if error != nil {
            print("hi2")
            self?.signinAid.textColor = UIColor.black
            self?.signinAid.text = "Invalid Login"
            return
        }
        self?.performSegue(withIdentifier: "signUserIn", sender: self)
      }
    }


}
