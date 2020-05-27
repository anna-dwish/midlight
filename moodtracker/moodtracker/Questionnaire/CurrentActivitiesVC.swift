//
//  CurrentActivitiesVC.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/17/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit

class CurrentActivitiesVC: UIViewController {

    @IBOutlet weak var currentActsText: UITextView!
    @IBOutlet weak var cook: UIButton!
    @IBOutlet weak var read: UIButton!
    @IBOutlet weak var pets: UIButton!
    @IBOutlet weak var art: UIButton!
    @IBOutlet weak var exercise: UIButton!
    @IBOutlet weak var media: UIButton!
    @IBOutlet weak var nature: UIButton!
    @IBOutlet weak var journal: UIButton!
    @IBOutlet weak var nextQuestion: UIButton!
    
   
    let NEUTRAL = UIColor(red: 226/255, green: 215/255, blue: 236/255, alpha: 1)
    let SELECTED = UIColor(red: 179/255, green: 165/255, blue: 201/255, alpha: 1)
    
    var actionsToStrings:[UIButton:String]? = nil
    var selectedActivities = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentActsText.text = NSLocalizedString("CURRENTACTSTEXT",comment:"")
        localizeActivityNames()
        nextQuestion.setTitle(NSLocalizedString("NEXT",comment:""),for:.normal)
        actionsToStrings = [cook:"Cooking/Baking",read:"Reading",
                            pets:"Playing with Pets",art:"Creating art",
                            exercise:"Exercise",media:"Watching media",
                            nature:"Being in nature",journal:"Journaling"]
    }
    func localizeActivityNames(){
        cook.setTitle(NSLocalizedString("COOK",comment:""),for:.normal)
        read.setTitle(NSLocalizedString("READ",comment:""),for:.normal)
        pets.setTitle(NSLocalizedString("PETS",comment:""),for:.normal)
        art.setTitle(NSLocalizedString("ART",comment:""),for:.normal)
        exercise.setTitle(NSLocalizedString("EXERCISE",comment:""),for:.normal)
        media.setTitle(NSLocalizedString("MEDIA",comment:""),for:.normal)
        nature.setTitle(NSLocalizedString("NATURE",comment:""),for:.normal)
        journal.setTitle(NSLocalizedString("JOURNAL",comment:""),for:.normal)
    }
    
    @IBAction func activityButtonClk(_ sender: UIButton) {
        if sender.backgroundColor == SELECTED{
            sender.backgroundColor = NEUTRAL
            selectedActivities.remove(actionsToStrings![sender]!)
        }
        else {
            sender.backgroundColor = SELECTED
            selectedActivities.insert(actionsToStrings![sender]!)
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
