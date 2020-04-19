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
    @IBOutlet weak var moodOne: UIButton!
    @IBOutlet weak var moodTwo: UIButton!
    @IBOutlet weak var moodThree: UIButton!
    @IBOutlet weak var moodFour: UIButton!
    @IBOutlet weak var moodFive: UIButton!
    
    
    var moods = [UIButton]()
    var selectedMood = 0
    let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)
    
    var newActivities = [String]()
    var currentActivities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moods = [moodOne,moodTwo,moodThree,moodFour,moodFive]
        retrieveUserSpecificActivities()
    }
    
    func retrieveUserSpecificActivities(){
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        let profileData = db.collection(userID!).document("profile")

        profileData.getDocument { (document, error) in
            if let document = document, document.exists {
                self.newActivities = document.data()!["newActivities"] as! Array<String>
                self.currentActivities = document.data()!["currentActivities"] as! Array<String>
          }
        }
    }
    
    @IBAction func setMood(_ sender: UIButton) {
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
        db.collection(userID!).document(today).updateData([
            "mood": selectedMood,
            "activities": [String]()
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
