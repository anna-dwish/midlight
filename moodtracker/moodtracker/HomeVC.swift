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
        
        var moods = [UIButton]()
        var selectedMood = 0
        let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)

        
        override func viewDidLoad() {
            super.viewDidLoad()
            getQuote()
            moods = [moodOne,moodTwo,moodThree,moodFour,moodFive]
            retrieveUserSpecificActivities()
        }
    
        override func viewDidAppear(_ animated: Bool) {
            //alert to go to update daily log when home page opened for the first time
            if (counter == 0){
                createAlert(title: "Daily Log", message: "Remember to log your mood today!")
                counter = 1
            }
        }
        
    //creates the alert to show on home page
        func createAlert (title: String, message: String){
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        func getQuote() {
            
            struct item: Codable {
                var quote: String
                var author: String
            }
            
            do {
                let path = Bundle.main.path(forResource: "quotes", ofType: "json")!
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                guard let quotesDict = json as? [String: [[String: String]]] else { return }
                
                let index = Int.random(in: 0...quotesDict.values.count)
                let q = quotesDict["quotes"]![index]
                quote.text = q["quote"]! + " -" + q["author"]!
            } catch {
                print(error)
            }
        }
        
        func retrieveUserSpecificActivities(){
            let db = Firestore.firestore()
            let userID = Auth.auth().currentUser?.uid
            let profileData = db.collection(userID!).document("profile")
            
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
            rec.text = "Try " + activity + " today!"
            recImage.image = UIImage(named: descToImage[activity]!)
            
        }
        
        func promptRandomActivity(){
            let str = descToImage.keys.randomElement()
            rec.text = "Try " + str! + " today!"
            recImage.image = UIImage(named: descToImage[str!]!)
        }
        
        @IBAction func setMood(_ sender: UIButton) {
           if !Reachability.isConnectedToNetwork(){
               let alert1 = UIAlertController(title: "Network Connectivity", message: "Unable to connect to network", preferredStyle: .alert) //.actionSheet
               alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alert1, animated: true)
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
            let db = Firestore.firestore()
            let userID = Auth.auth().currentUser?.uid
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let today = formatter.string(from: Date())
            
            let dailyInput = db.collection(userID!).document(today)
            dailyInput.getDocument { (document, error) in
                if let document = document {
                    if document.exists{
                       db.collection(userID!).document(today).updateData([
                        "mood": self.selectedMood
                       ])
                    }
                    else {
                        db.collection(userID!).document(today).setData([
                            "mood": self.selectedMood,
                            "activities": [String]()
                        ])
                    }
                }
            }
            
//            db.collection(userID!).document(today).updateData([
//                "mood": selectedMood,
//                "activities": [String]()
//            ]) { err in
//                if err != nil {
//                    db.collection(userID!).document(today).setData([
//                        "mood": self.selectedMood,
//                        "activities": [String]()
//                    ])
//                } else {
//                    print("Document successfully written!")
//                }
//            }
        }
        

        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

    }
