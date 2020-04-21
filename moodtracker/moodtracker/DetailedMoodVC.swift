//
//  detailedMoodVC.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/18/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit
import Firebase

class DetailedMoodVC: UIViewController {
    
    @IBOutlet weak var dateOfEntry: UILabel!
    @IBOutlet weak var mood: UIImageView!
    
    @IBOutlet weak var actOne: UIImageView!
    @IBOutlet weak var actTwo: UIImageView!
    @IBOutlet weak var actThree: UIImageView!
    @IBOutlet weak var actFour: UIImageView!
    @IBOutlet weak var actFive: UIImageView!
    @IBOutlet weak var actSeven: UIImageView!
    @IBOutlet weak var actEight: UIImageView!
    @IBOutlet weak var actNine: UIImageView!
    
    var dateOfMood:String = ""
    let moods = ["lowest","low","middle","high","highest"]
    let descToImage:[String:String] = ["Cooking/Baking":"cook","Reading":"read",
    "Playing with Pets":"pets","Creating art":"paint",
    "Exercise":"exercise","Watching media":"tv",
    "Being in nature":"nature","Journaling":"draw"]
    var acts = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateOfEntry.text = dateOfMood
        acts = [actOne,actTwo,actThree,actFour,actFive, actSeven,actEight,actNine]
        if !Reachability.isConnectedToNetwork(){
            let alert1 = UIAlertController(title: "Network Connectivity", message: "Unable to connect to network", preferredStyle: .alert) //.actionSheet
            alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert1, animated: true)
            return
        }
        displayEntryData()
    }
    
    func displayEntryData(){
        let entry = retrieveDocument()

        entry.getDocument { (document, error) in
            if let document = document, document.exists {
                let moodName = self.moods[document.data()!["mood"] as! Int]
                self.mood.image = UIImage(named:moodName)
                let newActivities = document.data()!["activities"] as! Array<String>
                var idx = 0
                for a in newActivities {
                    self.acts[idx].image = UIImage(named:self.descToImage[a]!)
                    idx = idx + 1
                }
           }
        }
    }
    
    func retrieveDocument() -> DocumentReference{
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        return(db.collection(userID!).document(dateOfMood))
        
    }

}
