//
//  NotificationManager.swift
//  YourApp
//
//  Created by honza on 05/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationManager: NSObject{
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notificationOptions: UNAuthorizationOptions = [.alert, .sound];
    private var currentTask: Task? = nil
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: notificationOptions) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
    }

    func addNotifiaction(_ task: Task) {
        requestAuthorization()
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
    
    func showAlert(title: String, message: String, view: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
