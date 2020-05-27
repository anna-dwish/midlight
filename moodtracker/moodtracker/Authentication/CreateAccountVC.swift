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
    
    @IBOutlet weak var enterEmailLabel: UILabel!
    @IBOutlet weak var enterPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccount.addTarget(self, action: #selector(enableAccount), for: .touchUpInside)
        createAccount.setTitle(NSLocalizedString("CREATEACCOUNT",comment:""), for: .normal)
        enterEmailLabel.text = NSLocalizedString("ENTEREMAIL",comment:"")
        enterPasswordLabel.text = NSLocalizedString("ENTERPASSWORD",comment:"")
        confirmPasswordLabel.text = NSLocalizedString("CONFIRMPASSWORD",comment:"")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func enableAccount(){
        if (email.text?.isEmpty ?? true || password.text?.isEmpty ?? true || confirmPassword.text?.isEmpty ?? true) {
            createAccountAid.textColor = UIColor.black
            createAccountAid.text = NSLocalizedString("MISSINGFIELDS",comment:"")
            return
        }
        else if (password.text != confirmPassword.text){
            createAccountAid.textColor = UIColor.black
            createAccountAid.text = NSLocalizedString("MISMATCHEDPASSWORDS",comment:"")
            return
        }
        else if !Reachability.isConnectedToNetwork() {
            let alert1 = UIAlertController(title: "Network Connectivity", message: "Unable to connect to network", preferredStyle: .alert) //.actionSheet
            alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert1, animated: true)
            return
        }

        validateAccount()
    }
        
    func validateAccount() {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { [weak self] authResult, error in
        if error != nil {
            self?.createAccountAid.textColor = UIColor.black
            self?.createAccountAid.text = NSLocalizedString("DUPLICATEEMAIL",comment:"")
            return
        }
            Auth.auth().signIn(withEmail: (self?.email.text)!, password: (self?.password.text)!)
            self?.createAccountAid.textColor = UIColor.white
            self?.performSegue(withIdentifier: "beginQuestionnaire", sender: self)
      }
        
    }

}
