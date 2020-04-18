//
//  CurrentActivitiesVC.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/17/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit

class CurrentActivitiesVC: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
    @IBAction func activityButtonClk(_ sender: UIButton) {
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
        performSegue(withIdentifier:"currentToNew",sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let vc = segue.destination as! NewActivitiesVC
        vc.currentActivities = selectedActivities
    }
    
    


}
