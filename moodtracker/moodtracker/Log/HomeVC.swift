//
//  HomeVC.swift
//  moodtracker
//
//  Created by Anna Darwish and Laura Li on 4/18/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//
import Firebase
import UIKit

class HomeVC: UIViewController {
        var counter = 0 //used to make sure the pop up alert only happens one time after the home page is visited
        
        @IBOutlet weak var moodOne: UIButton!
        @IBOutlet weak var moodTwo: UIButton!
        @IBOutlet weak var moodThree: UIButton!
        @IBOutlet weak var moodFour: UIButton!
        @IBOutlet weak var moodFive: UIButton!
        
        @IBOutlet weak var recImage: UIImageView!
        @IBOutlet weak var rec: UITextView!
        @IBOutlet weak var quote: UITextView!
 
        let descToImage:[String:String] = ["Cooking/Baking":"cook","Reading":"read",
        "Playing with Pets":"pets","Creating art":"paint",
        "Exercise":"exercise","Watching media":"tv",
        "Being in nature":"nature","Journaling":"draw"]
        let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)
            
        var moods = [UIButton]()
        var selectedMood = 0
        var receivedMoodInput = false

        
        override func viewDidLoad() {
            super.viewDidLoad()
            moods = [moodOne,moodTwo,moodThree,moodFour,moodFive]
            getQuote()
            retrieveUserSpecificActivities()
        }
    
        override func viewDidAppear(_ animated: Bool) {
            currentMoodIsAvailable()
        }
    
        func currentMoodIsAvailable() {
            if !Reachability.isConnectedToNetwork(){
                displayReachabilityAlert()
                return
            }
            let profileData = getDailyDocument()
            profileData.getDocument { (document, error) in
                if let document = document, document.exists {
                    let selected = self.moods[document.data()!["mood"] as! Int]
                    selected.backgroundColor = self.SELECTED
               }
                else {
                    self.createAlert(title: "Daily Log", message: "Remember to log your mood today!")
                }
            }
        }
        
        func createAlert (title: String, message: String){
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        func getQuote() {
            
//            struct item: Codable {
//                var quote: String
//                var author: String
//            }
//            
//            do {
//                let path = Bundle.main.path(forResource: "quotes", ofType: "json")!
//                let url = URL(fileURLWithPath: path)
//                let data = try Data(contentsOf: url)
//                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//                
//                guard let quotesDict = json as? [String: [[String: String]]] else { return }
//                
//                let index = Int.random(in: 0...quotesDict.values.count)
//                let q = quotesDict["quotes"]![index]
//                quote.text = q["quote"]! + " -" + q["author"]!
//            } catch {
//                print(error)
//            }
        }
        
        func retrieveUserSpecificActivities(){
            let profileData = getProfileDocument()
            
            profileData.getDocument { (document, error) in
                if let document = document, document.exists {
                    var activities = [String]()
                    activities = document.data()!["newActivities"] as! Array<String>
                    let currentActivities = document.data()!["currentActivities"] as! Array<String>
                    activities.append(contentsOf:currentActivities)
                    if (activities.count > 0){
                        self.promptUserActivity(options: activities)
                    }
                    else {
                        self.promptRandomActivity()
                    }
                    
              }
            }
        }
    
        func promptUserActivity(options:[String]){
            let ind = Int.random(in: 0..<options.count)
            let activity = options[ind]
            rec.text = "Try " + activity.lowercased() + " today!"
            recImage.image = UIImage(named: descToImage[activity]!)
            
        }
        
        func promptRandomActivity(){
            let str = descToImage.keys.randomElement()
            rec.text = "Try " + str!.lowercased() + " today!"
            recImage.image = UIImage(named: descToImage[str!]!)
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
            updateDatabase()
        }
        
        func updateDatabase(){
            let dailyInput = getDailyDocument()
            dailyInput.getDocument { (document, error) in
                if let document = document {
                    if document.exists{
                       dailyInput.updateData(["mood": self.selectedMood])
                    }
                    else {
                       dailyInput.setData(["mood": self.selectedMood,"activities": [String]()])
                    }
                }
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
        let alert1 = UIAlertController(title: "Network Connectivity", message: "Unable to connect to network", preferredStyle: .alert) //.actionSheet
        alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert1, animated: true)
    }
}
