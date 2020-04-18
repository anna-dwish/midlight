//
//  ProfileVCViewController.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/18/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var moodOne: UIButton!
    @IBOutlet weak var moodTwo: UIButton!
    @IBOutlet weak var moodThree: UIButton!
    @IBOutlet weak var moodFour: UIButton!
    @IBOutlet weak var moodFive: UIButton!
    
    var moods = [UIButton]()
    
    let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().signIn(withEmail: "ard51@duke.edu", password: "midlight")
        moods = [moodOne,moodTwo,moodThree,moodFour,moodFive]
        retrieveUserInfo()
        // Do any additional setup after loading the view.
    }
    
    func retrieveUserInfo(){
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        let profileData = db.collection(userID!).document("profile")
        displayName.text = Auth.auth().currentUser?.displayName

        profileData.getDocument { (document, error) in
            if let document = document, document.exists {
                self.moods[document.data()!["mood"] as! Int].backgroundColor = self.SELECTED
                
          }
        }
    }
    

}
