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
    
    @IBOutlet weak var quote: UITextView!
    
    var moods = [UIButton]()
    var selectedMood = 0
    let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)
    
    var newActivities = [String]()
    var currentActivities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuote()
        moods = [moodOne,moodTwo,moodThree,moodFour,moodFive]
        retrieveUserSpecificActivities()
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
            
            var index = Int.random(in: 0...quotesDict["quotes"]!.count)
            //var q = quotesDict.values.randomElement()
            //var q = quotesDict.values.
            //quote.text = quotesDict.values.randomElement()
            var q = quotesDict["quotes"]![index]
            quote.text = q["quote"]! + " -" + q["author"]!
            /*guard let all = quotesDict["quote"] as? [String: Any] else {
                print("not an array of dictionaries")
                return
            }*/
            
            
            //let data = try Data(contentsOf: url)
            //let quotesArray = try! JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: url)), options: JSONSerialization.ReadingOptions()) as? [Any]
            
            //var finalQuoteArray:[String] = []
            //var finalAuthorArray:[String] = []
            //var finalArray: [item] = []
            //print(quotesArray?[0])
            
            /*for dict in quotesArray! {
                //var quote: item
                
                if let dict = quotesArray as? [String: Any], let quoteArr = dict["quote"] as? [String] {
                    //quote.quote = quoteArr
                    finalQuoteArray.append(contentsOf: quoteArr)
                }
                if let dict = quotesArray as? [String: Any], let authorArr = dict["author"] as? [String] {
                    finalAuthorArray.append(contentsOf: authorArr)
                    //quote.author = authorArr
                }
            }*/
            //let num = finalQuoteArray.count
            //quote.text = finalQuoteArray[Int.random(in: 0...num)]
            
            //let decoder = JSONDecoder()
            //let model = try decoder.decode([item].self, from: data)
            //print(model.count)
            
            //var json = try? JSONSerialization.jsonObject(with: data)
            
            //print(json)
        } catch {
            print(error)
        }
        //quote.text
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
                db.collection(userID!).document(today).setData([
                    "mood": self.selectedMood,
                    "activities": [String]()
                ])
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
