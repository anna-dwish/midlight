//
//  MoodVC.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/17/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit

class MoodVC: UIViewController {
    @IBOutlet weak var moodOne: UIButton!
    @IBOutlet weak var moodTwo: UIButton!
    @IBOutlet weak var moodThree: UIButton!
    @IBOutlet weak var moodFour: UIButton!
    @IBOutlet weak var moodFive: UIButton!
    @IBOutlet weak var nextQuestion: UIButton!
    
    var newActivities = Set<String>()
    var currentActivities = Set<String>()
    var email = ""
    var password = ""
    
    var moods = [UIButton]()
    var selectedMood = 0
    
    let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextQuestion.isEnabled = false
        nextQuestion.backgroundColor = UIColor.lightGray
        moods = [moodOne,moodTwo,moodThree,moodFour,moodFive]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setMood(_ sender: UIButton) {
        nextQuestion.isEnabled = true
        nextQuestion.backgroundColor = SELECTED
        sender.backgroundColor = SELECTED
        selectedMood = moods.firstIndex(of: sender)!
        for m in moods {
            if m != sender{
                m.backgroundColor = UIColor.white
            }
        }
    }
    
    @IBAction func goToNextQuestion()
    {
        performSegue(withIdentifier:"moodToProfile",sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let vc = segue.destination as! ProfileCreatorVC
        vc.currentActivities = currentActivities
        vc.newActivities = newActivities
        vc.mood = selectedMood
        vc.email = email
        vc.password = password
    }


}
