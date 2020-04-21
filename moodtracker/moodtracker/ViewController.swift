//
//  ViewController.swift
//  moodtracker
//
//  Created by Anna Darwish on 3/18/20.
//  Copyright © 2020 Anna Darwish. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //notifies users that are not on the app @8pm to update their log
        let content = UNMutableNotificationContent()
        content.title = "Daily Log"
        content.body = "Remember to log your mood today!"
        content.sound = UNNotificationSound.default
        
        var notifTiming = DateComponents()
        notifTiming.hour = 20
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notifTiming, repeats: true)
        
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
    }


}

