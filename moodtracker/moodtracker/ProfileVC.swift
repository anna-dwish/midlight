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
    
    
    @IBOutlet weak var actOne: UIImageView!
    @IBOutlet weak var actTwo: UIImageView!
    @IBOutlet weak var actThree: UIImageView!
    @IBOutlet weak var actFour: UIImageView!
    @IBOutlet weak var actFive: UIImageView!
    @IBOutlet weak var actSix: UIImageView!
    @IBOutlet weak var actSeven: UIImageView!
    @IBOutlet weak var actEight: UIImageView!
    @IBOutlet weak var actNine: UIImageView!
    @IBOutlet weak var actTen: UIImageView!
    
    var moods = [UIButton]()
    var acts = [UIImageView]()
    let descToImage:[String:String] = ["Cooking/Baking":"cook","Reading":"read",
    "Playing with Pets":"pets","Creating art":"paint",
    "Exercise":"exercise","Watching media":"tv",
    "Being in nature":"nature","Journaling":"journalbook",
    "Talking":"talk","Other":"ellipsis"]
    
    let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moods = [moodOne,moodTwo,moodThree,moodFour,moodFive]
        acts = [actOne,actTwo,actThree,actFour,actFive,actSix, actSeven,actEight,actNine,actTen]
        if !Reachability.isConnectedToNetwork(){
            let alert1 = UIAlertController(title: "Network Connectivity", message: "Unable to connect to network", preferredStyle: .alert) //.actionSheet
            alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert1, animated: true)
            return
        }
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
                let newActivities = document.data()!["newActivities"] as! Array<String>
                var idx = 0
                for a in newActivities {
                    self.acts[idx].image = UIImage(named:self.descToImage[a]!)
                    idx = idx + 1
                }
                
          }
        }
    }
    

}
