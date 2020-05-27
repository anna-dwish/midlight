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
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var signin: UIButton!
    @IBOutlet weak var signinAid: UILabel!
    @IBOutlet weak var createAccount: UIButton!
    
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.signin.setTitle(NSLocalizedString("SIGNIN",comment:""), for: .normal)
        self.createAccount.setTitle(NSLocalizedString("CREATEACCOUNT",comment:""), for: .normal)
        self.passwordLabel.text = NSLocalizedString("PASSWORD",comment:"")
    }
    
    @IBAction func enableSignIn(){
        if (username.text?.isEmpty ?? true || password.text?.isEmpty ?? true) {
            signinAid.textColor = UIColor.black
            signinAid.text = NSLocalizedString("MISSINGFIELDS",comment:"")
            return
        }
        else if !Reachability.isConnectedToNetwork(){
            let alert1 = UIAlertController(title: "Network Connectivity", message: "Unable to connect to network", preferredStyle: .alert) //.actionSheet
            alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert1, animated: true)
            return
        }
        validateSignIn()
    }
        
    func validateSignIn(){
        Auth.auth().signIn(withEmail: username.text!, password: password.text!) { [weak self] authResult, error in
        if error != nil {
            self?.signinAid.textColor = UIColor.black
            self?.signinAid.text = NSLocalizedString("INVALIDLOGIN",comment:"")
            return
        }
        self?.signinAid.textColor = UIColor.white
        self?.performSegue(withIdentifier: "signUserIn", sender: self)
      }
    }


}
