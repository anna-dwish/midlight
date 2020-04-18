//
//  NewActivitiesVC.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/17/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit

class NewActivitiesVC: UIViewController {
    
    @IBOutlet weak var cook: UIButton!
    @IBOutlet weak var read: UIButton!
    @IBOutlet weak var pets: UIButton!
    @IBOutlet weak var art: UIButton!
    @IBOutlet weak var exercise: UIButton!
    @IBOutlet weak var media: UIButton!
    @IBOutlet weak var nature: UIButton!
    @IBOutlet weak var journal: UIButton!
    @IBOutlet weak var talk: UIButton!
    @IBOutlet weak var other: UIButton!
    @IBOutlet weak var nextQuestion: UIButton!
    
    let NEUTRAL = UIColor(red: 226/255, green: 215/255, blue: 236/255, alpha: 1)
    let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)
    
    var selectedActivities = Set<String>()
    var currentActivities = Set<String>()
    var email = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activities = [cook,read,pets,art,exercise,media,nature,journal,talk,other]
        for selectedAct in activities {
            if currentActivities.contains((selectedAct?.titleLabel?.text)!){
                selectedAct!.isEnabled = false
                selectedAct?.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction func activityButtonClk(_ sender: UIButton) {
        if !sender.isEnabled {
            return
        }
        if sender.backgroundColor == SELECTED{
            sender.backgroundColor = NEUTRAL
            selectedActivities.remove((sender.titleLabel?.text)!)
        }
        else {
            sender.backgroundColor = SELECTED
            selectedActivities.insert((sender.titleLabel?.text)!)
        }
    }
    
    @IBAction func goToNextQuestion()
    {
        performSegue(withIdentifier:"newToMood",sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let vc = segue.destination as! MoodVC
        vc.currentActivities = currentActivities
        vc.newActivities = selectedActivities
        vc.email = email
        vc.password = password
        
    }
}
