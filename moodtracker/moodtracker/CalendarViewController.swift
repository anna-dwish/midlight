// calendar view controller
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
//    @IBOutlet weak var currentMonth: UILabel!
    var selectedDate = ""
    var firstView = true
    var todayCell:DateCell? = nil
    let moods = ["lowest","low","middle","high","highest"]
    
    @IBOutlet weak var calendarView: JTACMonthView!
    
//    var todayCell:JTACDayCell? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("CALLED viewWillAppear")
        if firstView {
            firstView = false
            return
        }
        if !Reachability.isConnectedToNetwork(){
            displayConnectionAlert()
            return
        }
        print("Trying to update today...")
        if todayCell != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = "2020-04-21"
            let dailyMoodData = generateDocumentName(dateOfCell:dateString)
            dailyMoodData.getDocument { (document, error) in
                if let document = document, document.exists {
                    let moodName = self.moods[document.data()!["mood"] as! Int]
                    self.todayCell!.dailyMood.image = UIImage(named:moodName)
               }
            }
        }
        
    }
    
    func displayConnectionAlert(){
        let alert1 = UIAlertController(title: "Network Connectivity", message: "Unable to connect to network", preferredStyle: .alert) //.actionSheet
        alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert1, animated: true)
    }
    
    func generateDocumentName(dateOfCell:String) -> DocumentReference{
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        return(db.collection(userID!).document(dateOfCell))
    }

}

class DateHeader: JTACMonthReusableView  {
    @IBOutlet var monthTitle: UILabel!
}

extension CalendarViewController: JTACMonthViewDataSource {

    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let endDate = Date()
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: endDate)
        let startDate = formatter.date(from: formatter.string(from: Calendar.current.date(from: comp)!))
        return ConfigurationParameters(startDate: startDate!, endDate: endDate, generateInDates: .forAllMonths,
        generateOutDates: .tillEndOfGrid)
    }
    
}



extension CalendarViewController: JTACMonthViewDelegate {
    
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        
        cell.dateLabel.text = cellState.text
        if !Reachability.isConnectedToNetwork(){
            displayConnectionAlert()
            return cell
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from:date)
        let dailyMoodData = generateDocumentName(dateOfCell:dateString)

        dailyMoodData.getDocument { (document, error) in
            if let document = document, document.exists {
                let moodName = self.moods[document.data()!["mood"] as! Int]
                cell.segueButton.isEnabled = true
                cell.dailyMood.image = UIImage(named:moodName)
                cell.segueButton.setTitle(dateString, for: UIControl.State.normal)
                cell.segueButton.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
           }
        }
        if dateString == "2020-04-21"{
            todayCell = cell
        }
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
//        let cell = cell as! DateCell
//        cell.dateLabel.text = cellState.text
        configureCell(view: cell, cellState: cellState)
    }
    
    // inDates / outDates
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        cell.backgroundColor = UIColor(red: 226/255, green: 215/255, blue: 236/255, alpha: 1)
        
        
    }
        
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
       if cellState.dateBelongsTo == .thisMonth {
          cell.dateLabel.textColor = UIColor.black
       } else {
          cell.dateLabel.textColor = UIColor.gray
       }
    }
    
    // month header
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMMM"

        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 40)
    }
    
    
    @objc func buttonAction(sender: UIButton!) {
      if !Reachability.isConnectedToNetwork(){
          let alert1 = UIAlertController(title: "Network Connectivity", message: "Unable to connect to network", preferredStyle: .alert) //.actionSheet
          alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert1, animated: true)
          return
      }
      selectedDate = sender.title(for:UIControl.State.normal)!
      performSegue(withIdentifier:"monthToDay",sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let vc = segue.destination as! DetailedMoodVC
        vc.dateOfMood = selectedDate
    }
    
}


