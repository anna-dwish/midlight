//
//  DailyActivitiesVC.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/18/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit
import Firebase

class DailyActivitiesVC: UIViewController {

    @IBOutlet weak var actOne: UIButton!
    @IBOutlet weak var actTwo: UIButton!
    @IBOutlet weak var actThree: UIButton!
    @IBOutlet weak var actFour: UIButton!
    @IBOutlet weak var actFive: UIButton!
    @IBOutlet weak var actSix: UIButton!
    @IBOutlet weak var actSeven: UIButton!
    @IBOutlet weak var actEight: UIButton!
    
    let NEUTRAL = UIColor(red: 226/255, green: 215/255, blue: 236/255, alpha: 1)
    let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)
    var stringsToActions:[String:UIButton]? = nil
    var selectedActivities = Set<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stringsToActions = ["Cooking/Baking":actOne,"Reading":actTwo,
        "Playing with Pets":actThree,"Creating art":actFour,
        "Exercise":actFive,"Watching media":actSix,
        "Being in nature":actSeven,"Journaling":actEight]
        checkUserInput()
        // Do any additional setup after loading the view.
    }
    
    func checkUserInput(){
        let dailyInput = getDailyDocument()
        dailyInput.getDocument { (document, error) in
            if let document = document {
                if document.exists && document.get("activities") != nil{
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
    
    @IBAction func activityButtonClk(_ sender: UIButton) {
        if !Reachability.isConnectedToNetwork(){
            let alert1 = UIAlertController(title: "Network Connectivity", message: "Unable to connect to network", preferredStyle: .alert) //.actionSheet
            alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert1, animated: true)
            return
        }
        if sender.backgroundColor == SELECTED{
            sender.backgroundColor = NEUTRAL
            selectedActivities.remove(sender.titleLabel!.text!)
        }
        else {
            sender.backgroundColor = SELECTED
            selectedActivities.insert(sender.titleLabel!.text!)
        }
        updateDatabase()
    }
    
    func updateDatabase() {
        let dailyInput = getDailyDocument()
        dailyInput.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                   dailyInput.updateData(["activities": Array(self.selectedActivities)])
                }
                else {
                    let alert1 = UIAlertController(title: "Mood Input", message: "Please enter your mood first in Home", preferredStyle: .alert) //.actionSheet
                    alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert1, animated: true)
                    return
                }
            }
        }
        
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
    

}
