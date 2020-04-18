//
//  CalendarViewController.swift
//  moodtracker
//
//  Created by Anna Darwish on 4/10/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//
import Firebase
import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    var selectedDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

extension CalendarViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"

        let startDate = formatter.date(from: "2020 04 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension CalendarViewController: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let moods = ["lowest","low","middle","high","highest"]
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        
        cell.dateLabel.text = cellState.text
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from:date)
        let dailyMoodData = generateDocumentName(dateOfCell:dateString)

        dailyMoodData.getDocument { (document, error) in
            if let document = document, document.exists {
                let moodName = moods[document.data()!["mood"] as! Int]
                cell.segueButton.isEnabled = true
                cell.dailyMood.image = UIImage(named:moodName)
                cell.segueButton.setTitle(dateString, for: UIControl.State.normal)
                cell.segueButton.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
           }
        }
        return cell
    }
    
    func generateDocumentName(dateOfCell:String) -> DocumentReference{
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        return(db.collection(userID!).document(dateOfCell))
    }
    
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        cell.dateLabel.text = cellState.text
    }
    
    @objc func buttonAction(sender: UIButton!) {
      selectedDate = sender.title(for:UIControl.State.normal)!
      performSegue(withIdentifier:"monthToDay",sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let vc = segue.destination as! DetailedMoodVC
        vc.dateOfMood = selectedDate
    }
    
}

