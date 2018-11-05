//
//  SettingsViewController.swift
//  YourApp
//
//  Created by honza on 03/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingSwitchOutlet: UISwitch!
    @IBOutlet weak var newCategoryInputOutlet: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBAction func switchButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateSwitch), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func updateSwitch() {
        setupSwitch()
    }
    
    fileprivate func setupSwitch() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(){ (settings) in
            
            switch settings.alertSetting{
            case .enabled:
                self.settingSwitchOutlet.isOn = true
            case .disabled:
                self.settingSwitchOutlet.isOn = false
            case .notSupported:
                print("somethings wrong here")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupSwitch()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let newItem = Category(context: self.context)
        newItem.name = newCategoryInputOutlet.text
        saveItems()
    }
    func saveItems() {
        do {
            try context.save()
            print("Saving to CoreData")
        } catch {
            print("Error saving data to CoreData: \(error)")
        }
    }
}
