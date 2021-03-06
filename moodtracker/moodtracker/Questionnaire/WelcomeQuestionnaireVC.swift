//
//  WelcomeQuestionnaireVC.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/17/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit

class WelcomeQuestionnaire: UIViewController {

    @IBOutlet weak var welcomeText: UITextView!
    @IBOutlet weak var nextQuestion: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true);
        welcomeText.text = NSLocalizedString("WELCOME",comment:"")
        nextQuestion.setTitle(NSLocalizedString("NEXT",comment:""),for:.normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToNextQuestion()
    {
        performSegue(withIdentifier:"welcomeToCurrent",sender:self)
    }


}
