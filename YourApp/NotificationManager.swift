//
//  NotificationManager.swift
//  YourApp
//
//  Created by honza on 05/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    let notificationOptions: UNAuthorizationOptions = [.alert, .sound];
    var currentTask: Task? = nil
    let defaults = UserDefaults.standard
    var notificationRequests = [UNNotificationRequest]()
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: notificationOptions) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
    }

    func addNotifiaction(_ task: Task) {

        disableNotifications()
        currentTask = task
        let content = UNMutableNotificationContent()
        content.title = "Time is up!"
        content.body = task.title!
        content.sound = UNNotificationSound.default

        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: task.dueDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)

        notificationCenter.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
        
    }
    
    func disableNotifications() {
        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            self.notificationRequests = requests
            print(requests)
    })
    }
}
