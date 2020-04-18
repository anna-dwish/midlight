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
    @IBOutlet weak var actNine: UIButton!
    @IBOutlet weak var actTen: UIButton!
    
    let NEUTRAL = UIColor(red: 226/255, green: 215/255, blue: 236/255, alpha: 1)
    let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)
    var selectedActivities = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func activityButtonClk(_ sender: UIButton) {
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
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        db.collection(userID!).document(today).updateData([
            "activities": Array(selectedActivities)
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
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
