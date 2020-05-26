//
//  HomeVC.swift
//  moodtracker
//
//  Created by Anna Darwish and Laura Li on 4/18/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//
import Firebase
import UIKit
import SystemConfiguration

class HomeVC: UIViewController {
        var counter = 0 //used to make sure the pop up alert only happens one time after the home page is visited
        
        @IBOutlet weak var moodOne: UIButton!
        @IBOutlet weak var moodTwo: UIButton!
        @IBOutlet weak var moodThree: UIButton!
        @IBOutlet weak var moodFour: UIButton!
        @IBOutlet weak var moodFive: UIButton!
        
 
        @IBOutlet weak var cook: UIButton!
        @IBOutlet weak var read: UIButton!
        @IBOutlet weak var pets: UIButton!
        @IBOutlet weak var art: UIButton!
        @IBOutlet weak var exercise: UIButton!
        @IBOutlet weak var media: UIButton!
        @IBOutlet weak var nature: UIButton!
        @IBOutlet weak var journal: UIButton!
    
    
        let descToImage:[String:String] = ["Cooking/Baking":"cook","Reading":"read",
        "Playing with Pets":"pets","Creating art":"paint",
        "Exercise":"exercise","Watching media":"tv",
        "Being in nature":"nature","Journaling":"draw"]
        let NEUTRAL = UIColor(red: 226/255, green: 215/255, blue: 236/255, alpha: 1)
        let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)
            
        var moods = [UIButton]()
        var selectedActivities = Set<String>()
        var stringsToActions:[String:UIButton]? = nil
        var actionsToStrings:[UIButton:String]? = nil
        var selectedMood = 1
        var receivedMoodInput = false

        
        override func viewDidLoad() {
            super.viewDidLoad()
            moods = [moodOne,moodTwo,moodThree,moodFour,moodFive]
            
            stringsToActions = ["Cooking/Baking":cook,"Reading":read,
                                "Playing with Pets":pets,"Creating art":art,
                                "Exercise":exercise,"Watching media":media,
                                "Being in nature":nature,"Journaling":journal]
            
            actionsToStrings = [cook:"Cooking/Baking",read:"Reading",
                                pets:"Playing with Pets",art:"Creating art",
                                exercise:"Exercise",media:"Watching media",
                                nature:"Being in nature",journal:"Journaling"]
        }
    
        override func viewDidAppear(_ animated: Bool) {
            enterDailyLog()
        }
    
        override func viewDidDisappear(_ animated: Bool) {
               updateDatabase()
        }
    
        func enterDailyLog() {
            if !Reachability.isConnectedToNetwork(){
                displayReachabilityAlert()
                return
            }
            let profileData = getDailyDocument()
            profileData.getDocument { (document, error) in
                if let document = document, document.exists {
                    let selected = self.moods[document.data()!["mood"] as! Int]
                    selected.backgroundColor = self.SELECTED
                    if document.get("activities") != nil{
                        let loggedActivities = document.data()!["activities"] as! Array<String>
                        self.updateActivityDisplay(activities: loggedActivities)
                        self.selectedActivities.formUnion(Set(loggedActivities))
                    }
               }
            }
        }
    
        func updateActivityDisplay(activities:[String]) {
            for act in activities {
                self.stringsToActions![act]!.backgroundColor = SELECTED
            }
        }
        
        
        @IBAction func setMood(_ sender: UIButton) {
           if !Reachability.isConnectedToNetwork(){
               displayReachabilityAlert()
               return
           }
           sender.backgroundColor = SELECTED
           selectedMood = moods.firstIndex(of: sender)!
           for m in moods {
               if m != sender{
                   m.backgroundColor = UIColor.white
               }
           }
        }
    
        @IBAction func activityButtonClk(_ sender: UIButton) {
            if !Reachability.isConnectedToNetwork(){
                displayReachabilityAlert()
                return
            }
            if sender.backgroundColor == SELECTED{
                sender.backgroundColor = NEUTRAL
                selectedActivities.remove(actionsToStrings![sender]!)
            }
            else {
                sender.backgroundColor = SELECTED
                selectedActivities.insert(actionsToStrings![sender]!)
            }
        }
    
        
        func updateDatabase(){
            let dailyInput = getDailyDocument()
            dailyInput.getDocument { (document, error) in
                dailyInput.setData(["mood": self.selectedMood,"activities": Array(self.selectedActivities)])
              }
            }
            
    
        func getProfileDocument() -> DocumentReference{
            let db = Firestore.firestore()
            let userID = Auth.auth().currentUser?.uid
            let profileInput = db.collection(userID!).document("profile")
            return(profileInput)
        }
        
        func getDailyDocument() -> DocumentReference{
            let db = Firestore.firestore()
            let userID = Auth.auth().currentUser?.uid
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let today = formatter.string(from: Date())
            let dailyInput = db.collection(userID!).document(today)
            return(dailyInput)
        }
        
        func displayReachabilityAlert(){
            let alert1 = UIAlertController(title: "Network Connectivity", message: "Unable to connect to network", preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert1, animated: true)
        }
}
